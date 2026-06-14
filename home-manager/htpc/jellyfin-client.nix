{pkgs, ...}: {
  home.packages = with pkgs; [
    jellyfin-media-player
  ];

  # Tie into steam rom manager
  myHome.gaming.emulation.manifests.jellyfin = {
    target = "$jellyfin-desktop";
    launchOptions = "LD_PRELOAD= %command% --tv --fullscreen";
  };
}
