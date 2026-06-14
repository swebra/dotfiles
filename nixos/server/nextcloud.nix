{
  config,
  pkgs,
  private,
  ...
}: let
  nextcloudDir = "/mnt/nextcloud";
  nextcloudPort = 8098;
  subdomain = "nextcloud";
  # MAGIC VALUE: user/group name
  nextcloudUser = "nextcloud";
in {
  /*
  - https://wiki.nixos.org/wiki/Nextcloud
  - https://nixos.org/manual/nixos/stable/#module-services-nextcloud

  - TODO: Postgres backups
  */
  services.nextcloud = {
    enable = true;
    # MANUAL UPDATE: Needs to be manually incremented every major version
    package = pkgs.nextcloud33;
    home = nextcloudDir;

    # Initialization
    config = {
      adminuser = private.server.nextcloud.adminUser;
      # MANUAL SETUP: Initial admin password has to be manually set (TODO: secret management)
      adminpassFile = "/etc/nextcloud/admin-pass";
    };

    # DB
    config.dbtype = "pgsql";
    database.createLocally = true;

    # Internal networking config
    hostName = "${subdomain}.${private.server.domain}";
    maxUploadSize = "100G";
    https = false; # TLS handled by caddy instead

    # Apps are managed in web interface for easier update management
    extraAppsEnable = false;

    settings = {
      trusted_proxies = ["127.0.0.1"];
      default_phone_region = "CA";
      maintenance_window_start = 8; # 8am UTC == 1am MST == 2am MDT
    };

    phpOptions."opcache.interned_strings_buffer" = 16;
  };

  # Internal networking config, change listening port
  # https://wiki.nixos.org/wiki/Nextcloud#Change_default_listening_port
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    {
      addr = "127.0.0.1";
      port = nextcloudPort;
    }
  ];

  # Match user uid to that on the NAS
  users.users.${nextcloudUser}.uid = 1029;

  # MANUAL SETUP: Ownership and permissions of mount must be manually set
  # Having the share already mounted on initial activation worked for nextcloud-setup
  myOS.server.nfs.mount."nextcloud" = {
    to = nextcloudDir;
    existsFor = {
      # MAGIC VALUE: names of services
      services = ["nextcloud-setup" "nextcloud-cron" "nextcloud-update-db" "phpfpm-nextcloud"];
      user = nextcloudUser;
    };
  };

  # Web hosting is still done by NGINX using the Nix defaults, this just forwards to it
  # https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html
  myOS.server.caddy.subdomain.${subdomain} = ''
    redir /.well-known/carddav /remote.php/dav/ 301
    redir /.well-known/caldav /remote.php/dav/ 301
    header Strict-Transport-Security max-age=31536000;

    reverse_proxy http://localhost:${builtins.toString nextcloudPort} {
      # Nextcloud seems to be using the last X-Forwarded-For IP (not first), so just
      # give it the Caddy-derived client_ip directly instead
      header_up X-Forwarded-For {client_ip}
    }
  '';
}
