{config, ...}: {
  myHome = {
    dev = {
      enable = true;
      vscode-gui.enable = true;
    };
    gaming = {
      enable = true;
      mangohud.enable = false;
    };
    gui = {
      alacritty.enable = true;
      utilities.enable = true;
      zen-browser.enable = true;
    };
    htpc.enable = true;
  };

  # Home-manager config
  home.username = "eric";
  home.homeDirectory = "/home/${config.home.username}";

  # Do not update for new release cycle, see home manager docs
  home.stateVersion = "24.05"; # Did you read the comment?
}
