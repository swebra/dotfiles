{config, ...}: {
  myHome = {
    dev.enable = true;
    gaming.enable = true;
    gui.enable = true;
  };

  # Home-manager config
  home.username = "eric";
  home.homeDirectory = "/home/${config.home.username}";

  # Do not update for new release cycle, see home manager docs
  home.stateVersion = "24.11"; # Did you read the comment?
}
