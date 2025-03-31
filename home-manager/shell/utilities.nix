{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    wget
    termdown
  ];

  programs.jq = {
    enable = true;
    colors = {
      null = "2;33";
      false = "0;33";
      true = "0;33";
      numbers = "0;33";
      strings = "0;32";
      arrays = "1;37";
      objects = "1;37";
    };
  };

  programs.fastfetch = {
    enable = true;
    package = pkgs.emptyDirectory; # Don't need permanently installed, just keep the config
    settings.modules = [
      "title"
      "separator"

      # Hardware
      "os"
      "kernel"
      "uptime"
      {
        type = "localip";
        showPrefixLen = false;
      }
      "packages"
      "shell"
      # "de"
      # "wm"
      "terminalfont"

      # Software
      "break"
      {
        type = "cpu";
        temp = true;
        showPeCoreCount = true;
      }
      {
        type = "gpu";
        temp = true;
        driverSpecific = true;
        format = "{name} ({dedicated-total}) - {temperature}";
      }
      {
        type = "board";
        format = "{name}";
      }
      "memory"
      "disk"

      # Other
      "break"
      "datetime"
      "break"
      "colors"
    ];
  };
}
