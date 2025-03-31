{
  config,
  pkgs,
  ...
}: {
  myHome.gui.alacritty.enable = true;

  programs.alacritty = {
    package = pkgs.emptyDirectory;

    # Additional settings for Windows
    settings = {
      terminal.shell = {
        program = "wsl.exe";
        args = ["-d NixOS --cd ~"];
      };

      keyboard.bindings = [
        {
          key = "Back";
          mods = "Control";
          chars = "\\b";
        }
      ];
    };
  };

  opt.windows.syncPaths = [
    ["${config.xdg.configHome}/alacritty/alacritty.toml" "AppData/Roaming/alacritty/alacritty.toml"]
  ];
}
