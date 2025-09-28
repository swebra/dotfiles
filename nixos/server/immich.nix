{...}: {
  # systemctl status immich-server

  services.immich = {
    enable = true;
    host = "0.0.0.0"; # listen on IPv4, https://github.com/NixOS/nixpkgs/issues/446995
    openFirewall = true; # TODO: move behind caddy
  };

  # services.caddy.virtualHosts."julia.internal".extraConfig = ''
  #   reverse_proxy http://localhost:2283
  # '';
}
