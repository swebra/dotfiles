{config, ...}: let
  immichDir = "/mnt/photos";
in {
  # systemctl status immich-server
  # https://wiki.nixos.org/wiki/Immich

  services.immich = {
    enable = true;
    host = "127.0.0.1"; # listen on IPv4, only locally
    mediaLocation = immichDir;

    # Note that using hardware acceleration is an immich option that needs to be enabled
    accelerationDevices = ["/dev/dri/renderD128"];
  };

  # Immich relies user-only accessible files (-rw-------), therefore it plays best with
  # an NFS share with proper permissions and no user/group squashing. Immich user/group
  # IDs are set here to match the ones on the NAS, see comments at end of file.
  users = {
    users.${config.services.immich.user} = {
      uid = 1028;
      extraGroups = ["video" "render"]; # Extra access for hardware acceleration
    };
    groups.${config.services.immich.group}.gid = 65536;
  };

  # MANUAL: Ownership and permissions of mount must be manually set
  # ```
  # sudo chown immich:immich /mnt/photos
  # sudo chmod 0700 /mnt/photos
  # ```
  # See comments at end of file.
  myOS.server.nfs.mount."photos".to = immichDir;
  systemd.services.immich-server.unitConfig.RequiresMountsFor = immichDir;

  myOS.server.caddy.subdomain."photos" = ''
    reverse_proxy http://localhost:${builtins.toString config.services.immich.port}
  '';
}
# On Synology NFS user/group IDs:
# ---
# A Synology NAS doesn't natively allow you to set the IDs of the NAS users/groups to
# match your local system, instead you are expected to modify your local system to match
# to the NAS's IDs. While you can modify the NAS IDs of existing users/groups manually
# through SSH, there are reports of those values getting reset after updates.
# Conveniently, they also do not expose the uid/gid through the UI, therefore you have
# to retrieve them via SSH:
# ```
# sudo synouser --get immich
# sudo synogroup --get immich
# ```
# See https://community.synology.com/enu/forum/1/post/129603 for more details.
#
#
# On mount point ownership/permissions
# ---
# The service declaration does attempt to declaratively set ownership and permissions
# with systemd.tmpfiles, but that doesn't seem to work on the mount root, perhaps due to
# ordering of the mounting vs applying the permissions.
# https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/services/web-apps/immich.nix#L457
#
# I also tried to declaratively set ownership of the mount through a couple other means:
# - Using `uid`/`gid` mount options, but those aren't valid for an NFS mount
# - Using the `users` mount option, but that still didn't allow immich to write
# - Pointing immich at a subdir of the mount, and using systemd.tmpfiles to set
#   ownership/permissions of that subdir, but that still didn't allow immich to write
#
# At the end of the day, file ownership/permissions are metadata stored alongside the
# files, therefore part of the data and inherently imperative. systemd.tmpfiles is a bit
# of a hack, and it was easier just to manually set the ownership/permissions once.
# https://discourse.nixos.org/t/change-directory-permissions-declaratively/64072/

