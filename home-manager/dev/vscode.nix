{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = lib.mkMerge [
    # Manage VSCode app if gui.enabled
    (lib.mkIf config.myHome.gui.enable {
      nixpkgs.overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];

      programs.vscode = {
        enable = true;
        # Note: sometimes installing requires vscode restart
        extensions = with pkgs.vscode-marketplace; [
          zhuangtongfa.material-theme

          medo64.render-crlf
          stkb.rewrap
          streetsidesoftware.code-spell-checker

          github.copilot
          github.copilot-chat

          tamasfe.even-better-toml
          redhat.vscode-yaml
          jnoortheen.nix-ide
          ms-python.vscode-pylance
          ms-python.debugpy
          charliermarsh.ruff
        ];
      };

      xdg.configFile = let
        parentDir = "${config.myHome.dotfilesDir}/home-manager/dev";
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
