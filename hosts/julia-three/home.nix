{config, ...}: {
  myHome.dev.git.enable = true;

  # Home-manager config
  home.username = "julia";
  home.homeDirectory = "/home/${config.home.username}";

  # Do not update for new release cycle, see home manager docs
  home.stateVersion = "25.05"; # Did you read the comment?
}
