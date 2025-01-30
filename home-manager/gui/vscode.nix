{config, ...}: {
  programs.vscode = {
    enable = true;
  };

  # TODO: make option for dotfiles clone location
  xdg.configFile = let
    parentDir = "${config.home.homeDirectory}/.dotfiles/home-manager/gui";
    mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink "${parentDir}/${path}";
  in {
    "Code/User/settings.json".source = mkOutOfStoreSymlink "vscode-config/settings.jsonc";
    "Code/User/keybindings.json".source = mkOutOfStoreSymlink "vscode-config/keybindings.jsonc";
  };

  # TODO: Make a vscode-remote option that doesn't enable VSCode but handles extending the git config
}
