{config, ...}: let
  immichDir = "/mnt/photos";
in {
  # systemctl status immich-server

  services.immich = {
    enable = true;
    host = "127.0.0.1"; # listen on IPv4, only locally
    mediaLocation = immichDir;

    accelerationDevices = ["/dev/dri/renderD128"];
  };
  # Access for hardware acceleration
  users.users.${config.services.immich.user}.extraGroups = ["video" "render"];

  # immich user should get ownership of this by the immich tmpfiles settings
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/web-apps/immich.nix#L415
  myOS.server.nfs.mount."photos".to = immichDir;
  systemd.services.immich-server.unitConfig.RequiresMountsFor = immichDir;

  myOS.server.caddy.subdomain."photos" = ''
    reverse_proxy http://localhost:${builtins.toString config.services.immich.port}
  '';
}
# TODO:
# - Adjust backup and database dump settings
#   - https://docs.immich.app/administration/backup-and-restore
#   - https://docs.immich.app/guides/template-backup-script
#   - https://wiki.nixos.org/wiki/Immich#Using_borg_for_backups

