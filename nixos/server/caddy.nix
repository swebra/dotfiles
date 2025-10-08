{
  pkgs,
  private,
  ...
}: {
  # https://wiki.nixos.org/wiki/Caddy
  # https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148
  # https://drafts.msfjarvis.dev/posts/creating-private-services-on-nixos-using-tailscale-and-caddy/

  networking.firewall.allowedTCPPorts = [80 443];

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
      hash = "sha256-p9AIi6MSWm0umUB83HPQoU8SyPkX5pMx989zAi8d/74=";
    };

    email = private.personal.email;
    globalConfig = ''
      acme_dns cloudflare {env.CF_API_TOKEN}
    '';

    # Contains `CF_API_TOKEN=my_token`
    # TODO: use secret management
    environmentFile = "/run/secrets/caddy.env";

    virtualHosts."julia.internal".extraConfig = ''
      respond "Hello, world! Working from local network on port 443!"
    '';
  };
}
