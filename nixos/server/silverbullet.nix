{config, ...}: let
  sbDir = "/mnt/notes";
in {
  services.silverbullet = {
    enable = true;
    listenPort = 8097;
    spaceDir = sbDir;
    # MANUAL SETUP: User auth is manually set (TODO: secret management)
    # Contains `SB_USER=user:password`
    envFile = "/etc/silverbullet/silverbullet.env";
  };

  # MANUAL SETUP: Ownership of mount must be manually set. Currently squashing to admin.
  myOS.server.nfs.mount."notes" = {
    to = sbDir;
    existsFor = {
      services = ["silverbullet"];
      user = config.services.silverbullet.user;
      group = config.services.silverbullet.group;
    };
  };

  myOS.server.caddy.subdomain."notes" = ''
    reverse_proxy http://localhost:${builtins.toString config.services.silverbullet.listenPort}
  '';
}
