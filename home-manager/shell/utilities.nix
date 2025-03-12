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
}
