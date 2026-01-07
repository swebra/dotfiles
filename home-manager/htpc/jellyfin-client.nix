{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    jellyfin-media-player
  ];

  # Tie into steam rom manager
  myHome.gaming.emulation.manifests.jellyfin = {
    target = "${config.home.homeDirectory}/.nix-profile/bin/jellyfinmediaplayer";
    launchOptions = "LD_PRELOAD= %command% --tv --fullscreen";
  };
}
