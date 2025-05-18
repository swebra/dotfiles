{config, ...}: {
  myHome = {
    dev = {
      enable = true;
      vscode-gui.enable = true;
    };
    gui = {
      zen-browser.enable = true;
    };
  };

  # Home-manager config
  home.username = "deck";
  home.homeDirectory = "/home/${config.home.username}";

  # Do not update for new release cycle, see home manager docs
  home.stateVersion = "24.11"; # Did you read the comment?
}
