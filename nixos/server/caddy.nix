{
  config,
  lib,
  pkgs,
  private,
  ...
}: {
  /*
  https://wiki.nixos.org/wiki/Caddy
  https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148
  https://caddyserver.com/docs/caddyfile/options#trusted-proxies

  Future:
  - https://github.com/mholt/caddy-dynamicdns
  - https://drafts.msfjarvis.dev/posts/creating-private-services-on-nixos-using-tailscale-and-caddy/

  Other TODO: fail2ban, crowdsec, geolocation filtering, etc.
  */
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
    services.caddy = {
      enable = true;
      openFirewall = true;
      # MANUAL UPDATE: Plugins are manually updated
      package = pkgs.caddy.withPlugins {
        plugins = [
          # Handles SSL, DNS challenges
          "github.com/caddy-dns/cloudflare@v0.2.4"
          # Fetches up to date list of Cloudflare IPs
          # Version has to be manually fetched: https://wiki.nixos.org/wiki/Caddy#Plug-ins
          "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
        ];
        hash = "sha256-YkYxSjjEx+/vGN/cVqZvmTYKvxa44x75v/r38OqxqaY=";
      };

      email = private.personal.email;
      globalConfig = ''
        acme_dns cloudflare {env.CF_API_TOKEN}

        servers {
          trusted_proxies cloudflare {
            interval 12h  # www.cloudflare.com/ips/ fetching interval
            timeout 30s
          }
          # Determine "real" client IP first by looking for Cloudflare's custom header,
          # followed by looking at the right-most X-Forwarded-For IP. This ordering was
          # proven by experimentation, the docs for trusted_proxies_strict don't make it
          # clear if client_ip_headers also have to be reversed (they don't).
          client_ip_headers Cf-Connecting-Ip X-Forwarded-For
          trusted_proxies_strict # Right-to-left prioritization if multiple IPs
        }
      '';

      # MANUAL SETUP: Cloudflare API token is manually set (TODO: secret management)
      # Contains `CF_API_TOKEN=my_token`
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
