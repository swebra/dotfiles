{pkgs, ...}: {
  home.packages = with pkgs; [
    jellyfin-desktop # Soon to be renamed to jellium-desktop
  ];

  # Tie into steam rom manager
  myHome.gaming.emulation.manifests = {
    jellyfin = {
      target = pkgs.jellyfin-desktop;
      launchOptions = "LD_PRELOAD= %command% --tv --fullscreen";
    };
  };
}
