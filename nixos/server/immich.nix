{config, ...}: {
  # systemctl status immich-server

  services.immich = {
    enable = true;
    host = "127.0.0.1"; # listen on IPv4
  };

  # myOS.server.caddy.subdomain."photos" = ''
  #   reverse_proxy http://localhost:${builtins.toString config.services.immich.port}
  # '';

  services.caddy.virtualHosts."julia.internal".extraConfig = ''
    reverse_proxy http://localhost:${builtins.toString config.services.immich.port}
  '';
}
# TODO:
# - NAS mount
# - hardware transcoding
# - backup and database dump settings
# - email provider?

