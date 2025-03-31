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
    settings.modules = [
      "title"
      "separator"

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

      "break"
      "datetime"
      "break"
      "colors"
    ];
  };
}
