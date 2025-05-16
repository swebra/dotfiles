{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    jellyfin-media-player
  ];

  # Tie into steam-rom-manager
  # TODO: Create steam-rom-manager module
  home.file."Games/Emulation/roms/manifests/jellyfin.json".text = builtins.toJSON {
    title = "Jellyfin";
    target = "${config.home.homeDirectory}/.nix-profile/bin/jellyfinmediaplayer";
    launchOptions = "LD_PRELOAD= %command% --tv --fullscreen";
  };
}
