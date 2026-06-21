{
  config,
  lib,
  pkgs,
  ...
}: {
  /*
  - https://wiki.nixos.org/wiki/NFS
  - https://nixos.wiki/wiki/NFS


  General notes
  ---
  - `fileSystems.<mount-point>` is creating an `/etc/fstab` entry, which is then
    converted into a systemd mount unit by `systemd-fstab-generator`.
  - NFS mounts are implicitly dependent on network
    - see the `_netdev` option in `man systemd.mount`
    - see `systemctl list-dependencies <your-nfs-mount>.mount`

  On mount point ownership/permissions
  ---
  Some services try to set directory ownership with systemd.tmpfiles, but that doesn't
  always work. At the end of the day, file ownership/permissions are metadata stored
  alongside the files, therefore part of the data and inherently imperative.
  https://discourse.nixos.org/t/change-directory-permissions-declaratively/64072/

  The existsFor ownership checking (not setting) is therefore added to catch wrong
  owners at active or service start time, to inform manual, imperative intervention.

  Other "declarative" attempts that also didn't work:
  - Using systemd.tmpfiles but on a subdir
  - Using `uid`/`gid` mount options (not valid for an NFS mount)
  - Using the `users` mount option

  See also Synology-specific notes at the bottom of the doc.
  */
  options = {
    myOS.server.nfs = {
      mount = lib.mkOption {
        type = let
          mountOptions = {name, ...}: {
            options = {
              to = lib.mkOption {
                type = lib.types.str;
                description = "Local mount point path.";
              };
              options = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = "List of mount options.";
                default = [];
              };
              existsFor = {
                services = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = ''
                    Services that should require the mount to exist and be owned by the
                    provided user and group.
                  '';
                  default = [];
                };
                user = lib.mkOption {
                  type = lib.types.str;
                  description = "The user that the mount should be owned by.";
                };
                group = lib.mkOption {
                  type = lib.types.str;
                  description = ''
                    The group that the mount should be owned by. Defaults to `user`.
                  '';
                  default = config.myOS.server.nfs.mount.${name}.existsFor.user;
                };
              };
            };
          };
        in
          lib.types.attrsOf (lib.types.submodule mountOptions);
        description = ''
          Attribute set mapping of remote NFS paths to local mount point.

          `nfs.<nfs volume name>.to = "<local mount point>";`
        '';
        default = {};
      };

      address = lib.mkOption {
        type = lib.types.str;
        description = "IP address of the NFS server (NAS) to mount from.";
        default = "192.168.1.110";
      };
    };
  };

  config = {
    boot.supportedFilesystems = ["nfs"];

    # Create an NFS mount for each entry in config.myOS.server.nfs.mount
    fileSystems =
      lib.mapAttrs' (nfsVolume: mountAttrs: {
        name = mountAttrs.to;
        value = {
          device = "${config.myOS.server.nfs.address}:/volume1/${nfsVolume}";
          fsType = "nfs"; # TODO: NFS version? options = ["defaults"] ++ mountAttrs.options;
        };
      })
      config.myOS.server.nfs.mount;

    # Add mount requirements and ownership checking for all `existsFor.services` across
    # all mounts
    systemd.services = let
      /*
      Given a mount attrset, convert to a systemd.services attrset with a
      RequiresMountsFor and an ownership-checking ExecCondition for each service in
      existsFor.services. These service properties will be additive to the full service
      definition (e.g. immich) after nix does its merging.

      {to: "foo", enforce: {"services": ["one", "two"], name: "foo", group: "foo"}}
      -> {"one": {...}, "two": {...}}
      */
      mountToServices = _nfsVolume: mountAttrs: let
        mountPath = mountAttrs.to;
        ownerScript = getOwnerScript mountPath mountAttrs.existsFor;
      in
        lib.genAttrs mountAttrs.existsFor.services
        (_serviceName: {
          # Single-element lists so multiples are merged together and do not conflict
          unitConfig.RequiresMountsFor = [mountPath];
          serviceConfig.ExecCondition = [ownerScript];
        });

      # Generate a script binary which checks ownership
      getOwnerScript = mountPath: ownerInfo: let
        ownerStr = "${ownerInfo.user}:${ownerInfo.group}";
        stat = lib.getExe' pkgs.coreutils "stat";
      in
        pkgs.writeShellScript "check-nfs-mount-owner" ''
          user_group=$(${stat} -c "%U:%G" "${mountPath}" 2>/dev/null)
          if [[ "$user_group" != "${ownerStr}" ]]; then
            echo 'NFS mount ownership check failed, ${mountPath} is not owned by ${ownerStr}'
            echo 'Setting the owner may require disabling any mapping, see nfs.nix comments'
            exit 255  # Required for ExecCondition to cause non-silent failure
          fi
        '';
    in
      # Get a systemd.services attribute set from each mount and merge them together
      lib.mkMerge (lib.mapAttrsToList mountToServices config.myOS.server.nfs.mount);

    # Assert that no extra services were created through above
    assertions = let
      # Check if a service config has a running command, if not the service was probably
      # erroneously newly declared by existsFor. service.{script,postStart,etc} don't
      # need to be checked as they trickle down to these values anyways.
      hasACommand = serviceConfig:
        builtins.any (x: x)
        (builtins.map (cmd: builtins.hasAttr cmd serviceConfig && serviceConfig.${cmd} != "") [
          "ExecStart"
          "ExecStartPre"
          "ExecStartPost"
          "ExecReload"
          "ExecReload"
          "ExecReloadPost"
          "ExecStop"
          "ExecStopPost"
        ]);

      checkServicesArentNew = nfsVolume: mountAttrs:
        lib.forEach mountAttrs.existsFor.services (
          serviceName: {
            assertion = hasACommand config.systemd.services.${serviceName}.serviceConfig;
            message = "NFS mount '${nfsVolume}' references service '${serviceName}' which does not seem to exist.";
          }
        );
    in
      lib.flatten (lib.mapAttrsToList checkServicesArentNew config.myOS.server.nfs.mount);
  };
}
/*
On Synology user/groups
---
List of users:
- guest (uid 1025), member of the `users` group
- admin (uid 1024), member of the `users` and `administrators` groups
  - Note: not
- root (uid 0), primary GID of 0, only member of other internal groups (`log`, `daemon`)

List of groups:
- users (gid 100)
- administrators (gid 100)

Of these, only the `root` user and the `users` group have standard IDs, matching a
regular linux system. Note that `admin` user is not the `root` user, and does not have
special privileges with respect to changing file ownership.

With no squash/user mapping
---
Synology share permissions control access to the share as whole, but otherwise things
work as expected based on linux file permissions when considering same UID/GIDs.

If the Synology `users` group is given access, normal client users not otherwise on the
NAS (eric, julia, etc.) will be able to interact with the share based on being in the
client `users` group (same GID).

A client system user only in their own group (e.g. `immich:immich`) will not have access
the share as no equal UID/GID user/group exists on the NAS nor has been given access.

The root user also has the same UID/GID, so `sudo` actions works as expected. This seems
to be the only way to set the ownership of the share root.

As an example of the Synology permission affecting access, note how the `julia` user
can't access the share when the `users` group hasn't been given permission despite it
being owned by the user:
```shell
[julia@julia-three]$ sudo chown 'julia:users' -R test_mount/
[julia@julia-three]$ ls -l
. d--------- julia users test_mount
[julia@julia-three$ sudo ls -l
. drwxrwxrwx julia users test_mount
[julia@julia-three]$ ls test_mount ls: cannot open directory
'test_mount/': Permission denied
```

With squash/user mapping
---
While Synology share permissions still control access and linux file permissions still
apply, all client actions are done as the mapped user (`admin` or `guest`) so
access/permissions are based on that user and its group. Any newly written files will be
owned by the mapped user, files are read as the mapped user, and non-traditional
write-like actions such as changing file ownership/permissions are performed by the
mapped user.

If squashing all to the `guest` user, either the `guest` user or its `users` group must
be given access to the share before any downstream client can access the share. At that
point however, any client user can access the share regardless of their client uid,
group membership, etc.

The root user is also mapped, so `sudo` still executes as the mapped user instead of
root; No elevated permissions are available, you can't change the owner or file
permissions of something you don't know own, change the owner of the share root, etc.

Note that any existing file ownership/permissions are not modified when changing squash
modes. As a result, files from before the share was squashing can become inaccessible in
unintuitive ways, for example a file only readable by userA no longer being able to be
read by userA (because that read is actually being performed as the mapped user.)

Setting up matching user/group IDs for unmapped share
---
Synology doesn't natively allow you to set the IDs of the NAS users/groups to match your
local system, instead you are expected to modify your local system to match to the NAS's
IDs. While you can modify the NAS IDs of existing users/groups manually through SSH,
there are reports of those values getting reset after updates. Conveniently, they also
do not expose the NAS IDs through the UI, therefore you have to retrieve them via SSH:
```
sudo synouser --get immich
sudo synogroup --get immich
```
See https://community.synology.com/enu/forum/1/post/129603 for more details.
*/

