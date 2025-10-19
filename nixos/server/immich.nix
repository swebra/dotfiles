{config, ...}: let
  immichDir = "/mnt/photos";
in {
  # systemctl status immich-server

  services.immich = {
    enable = true;
    host = "127.0.0.1"; # listen on IPv4
    mediaLocation = immichDir;
  };

  # immich user should get ownership of this by the immich tmpfiles settings
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/web-apps/immich.nix#L415
  myOS.server.nfs.mount."photos".to = immichDir;
  systemd.services.immich-server.unitConfig.RequiresMountsFor = immichDir;

  myOS.server.caddy.subdomain."photos" = ''
    reverse_proxy http://localhost:${builtins.toString config.services.immich.port}
  '';
}
# TODO:
# - hardware transcoding
# - backup and database dump settings
# - email provider?

