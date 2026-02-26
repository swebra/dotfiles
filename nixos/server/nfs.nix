{
  config,
  lib,
  ...
}: {
  # https://wiki.nixos.org/wiki/NFS
  # https://nixos.wiki/wiki/NFS

  # Notes:
  # - `fileSystems.<mount-point>` is creating an `/etc/fstab` entry, which is then
  #   converted into a systemd mount unit by `systemd-fstab-generator`.
  # - NFS mounts are implicitly dependent on network
  #   - see the `_netdev` option in `man systemd.mount`
  #   - see `systemctl list-dependencies <your-nfs-mount>.mount`

  options = {
    myOS.server.nfs = {
      mount = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
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
          };
        });
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
          fsType = "nfs";
          # TODO: NFS version?
          options = ["defaults"] ++ mountAttrs.options;
        };
      })
      config.myOS.server.nfs.mount;
  };
}
