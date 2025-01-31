{
  config,
  lib,
  ...
}: {
  config = lib.mkMerge [
    # Manage VSCode app if gui.enabled
    (lib.mkIf config.myHome.gui.enable {
      programs.vscode = {
        enable = true;
      };

      # TODO: make option for dotfiles clone location
      xdg.configFile = let
        parentDir = "${config.home.homeDirectory}/.dotfiles/home-manager/dev";
        mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink "${parentDir}/${path}";
      in {
        "Code/User/settings.json".source = mkOutOfStoreSymlink "vscode-config/settings.jsonc";
        "Code/User/keybindings.json".source = mkOutOfStoreSymlink "vscode-config/keybindings.jsonc";
      };
    })

    # Always manage non-GUI config for when system is used for remote dev (like in WSL)
    {
      programs.git = {
        ignores = [".vscode"];

        extraConfig = {
          diff.tool = "vscode";
          difftool = {
            prompt = false;
            vscode.cmd = "code --wait --diff $LOCAL $REMOTE";
          };

          merge.tool = "vscode";
          mergetool = {
            keepBackup = "false";
            vscode.cmd = "code --wait $MERGED";
          };
        };
      };
    }
  ];
}
