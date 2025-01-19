{config, ...}: {
  imports = [
    ../../home-manager
  ];

  myHome = {
    dev.enable = true;
    gui.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Home-manager config
  home.username = "eric";
  home.homeDirectory = "/home/${config.home.username}";

  # Do not update for new release cycle, see home manager docs
  home.stateVersion = "24.11"; # Did you read the comment?
}
