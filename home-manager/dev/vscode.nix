{
  config,
  lib,
  pkgs,
  pkgs-unstable,
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
        package = pkgs-unstable.vscode;
        # Note: extension changes sometimes requires vscode restart
        extensions =
          (with pkgs.vscode-marketplace; [
            zhuangtongfa.material-theme

            medo64.render-crlf
            streetsidesoftware.code-spell-checker

            tamasfe.even-better-toml
            redhat.vscode-yaml
            jnoortheen.nix-ide
            ms-python.vscode-pylance
            ms-python.debugpy
            charliermarsh.ruff
          ])
          ++ (with pkgs.vscode-marketplace-release; [
            stkb.rewrap
            github.copilot
            github.copilot-chat
          ]);
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
