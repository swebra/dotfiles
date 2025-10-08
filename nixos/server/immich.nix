{
  config,
  private,
  ...
}: {
  # systemctl status immich-server

  services.immich = {
    enable = true;
    host = "127.0.0.1"; # listen on IPv4
  };

  services.caddy.virtualHosts."photos.${private.server.domain}".extraConfig = ''
    reverse_proxy http://localhost:${builtins.toString config.services.immich.port}
  '';
}
# TODO:
# - NAS mount
# - hardware transcoding
# - backup and database dump settings
# - email provider?

