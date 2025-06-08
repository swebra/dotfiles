{pkgs, ...}: {
  home.packages = with pkgs; [
    vlc
    mission-center
  ];
}
