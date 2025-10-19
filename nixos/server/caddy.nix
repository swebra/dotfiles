{
  config,
  lib,
  pkgs,
  private,
  ...
}: {
  # https://wiki.nixos.org/wiki/Caddy
  # https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148
  # https://drafts.msfjarvis.dev/posts/creating-private-services-on-nixos-using-tailscale-and-caddy/

  # TODO:
  # - cloudflare trusted proxy settings
  #   - https://github.com/WeidiDeng/caddy-cloudflare-ip
  #   - https://developers.cloudflare.com/support/troubleshooting/restoring-visitor-ips/restoring-original-visitor-ips/#caddy
  #   - https://www.cloudflare.com/en-ca/ips/
  #   - https://caddyserver.com/docs/caddyfile/options#trusted-proxies

  options = {
    myOS.server.caddy.subdomain = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = ''
        Attribute set mapping of subdomains to Caddy configuration.

        `caddy.subdomain.<subdomain> = "<Caddyfile options>";`
      '';
      default = {};
    };
  };

  config = {
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
      environmentFile = "/etc/caddy/caddy.env";

      virtualHosts =
        # Create a virtual host for each subdomain in myOS.server.caddy.subdomain
        lib.mapAttrs' (subdomain: config: {
          name = "${subdomain}.${private.server.domain}";
          value = {
            extraConfig = config;
          };
        })
        config.myOS.server.caddy.subdomain
        # Catch all other unhandled subdomains
        // {
          "*.${private.server.domain}".extraConfig = ''
            error * 404
            handle_errors {
              redir https://${private.server.domain}/404.html
            }
          '';
        };
    };
  };
}
