{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  sbDir = "/mnt/notes";
in {
  services.silverbullet = {
    enable = true;
    package = pkgs-unstable.silverbullet;
    listenPort = 8097;
    spaceDir = sbDir;
  };

  # Make git available until nixpkgs service catches up
  systemd.services.silverbullet.path = [pkgs.git];

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
