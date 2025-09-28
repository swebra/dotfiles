{...}: {
  # https://wiki.nixos.org/wiki/Caddy
  # https://aottr.dev/posts/2024/08/homelab-setting-up-caddy-reverse-proxy-with-ssl-on-nixos/
  # https://github.com/NixOS/nixpkgs/pull/358586

  networking.firewall.allowedTCPPorts = [80 443];

  services.caddy = {
    enable = true;

    virtualHosts."julia.internal".extraConfig = ''
      respond "Hello, world! Working!"
      # reverse_proxy http://localhost:2283
    '';
  };
}
