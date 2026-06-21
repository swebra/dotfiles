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

  # Immich relies on owned, user-only accessible files (-rw-------), therefore it plays
  # best with an NFS share with proper permissions and no user/group squashing. Setting
  # user/group IDs to match the ones on the NAS.
  users = {
    users.${config.services.immich.user} = {
      uid = 1028;
      extraGroups = ["video" "render"]; # Extra access for hardware acceleration
    };
    groups.${config.services.immich.group}.gid = 65536;
  };

  # MANUAL SETUP: Ownership and permissions of mount must be manually set
  # ```
  # sudo chown immich:immich /mnt/photos
  # sudo chmod 0700 /mnt/photos
  # ```
  myOS.server.nfs.mount."photos" = {
    to = immichDir;
    existsFor = {
      # MAGIC VALUE: name of service
      services = ["immich-server"];
      user = config.services.immich.user;
      group = config.services.immich.group;
    };
  };

  myOS.server.caddy.subdomain."photos" = ''
    reverse_proxy http://localhost:${builtins.toString config.services.immich.port}
  '';
}
