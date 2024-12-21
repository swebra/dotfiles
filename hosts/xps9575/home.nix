{config, ...}: {
  imports = [
    ../../home-manager
  ];

  # Home Manager
  # ------------
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "eric";
  home.homeDirectory = "/home/${config.home.username}";

  # Do not update for new release cycle, see home manager docs
  home.stateVersion = "24.11"; # Did you read the comment?
}
