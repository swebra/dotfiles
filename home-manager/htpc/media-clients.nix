{pkgs, ...}: {
  home.packages = with pkgs; [
    jellyfin-desktop # Soon to be renamed to jellium-desktop
    vacuum-tube
  ];

  # Tie into steam rom manager
  myHome.gaming.emulation.manifests = {
    jellyfin = {
      target = pkgs.jellyfin-desktop;
      launchOptions = "LD_PRELOAD= %command% --tv --fullscreen";
    };

    youtube = {
      target = pkgs.vacuum-tube;
      launchOptions = "LD_PRELOAD= %command% --fullscreen";
    };
  };
}
