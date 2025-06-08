{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  options = {
    myHome.dev.vscode-gui.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.myHome.gui.enable;
      description = ''
        Whether to enable the VSCode GUI application and its configuration. Defaults to the same
        value as `myHome.gui.enable` when not explicitly set. When false, the
        `myHome.dev.vscode.enable` setting still controls VSCode-related non-GUI config like git
        configuration.
      '';
    };
  };

  config = lib.mkMerge [
    # Manage VSCode app if gui is generally enabled or if vscode-gui is explicitly enabled
    (lib.mkIf config.myHome.dev.vscode-gui.enable {
      nixpkgs.overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];

      programs.vscode = {
        enable = true;
        package = pkgs-unstable.vscode;
        # Note: extension changes sometimes requires vscode restart
        profiles.default.extensions =
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
