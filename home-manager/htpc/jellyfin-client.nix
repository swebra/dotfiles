{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    jellyfin-media-player
  ];

  # TODO: Create steam-rom-manager module
  xdg.configFile."steam-rom-manager/userData/manifests/jellyfin.json".text = builtins.toJSON {
    title = "Jellyfin";
    target = "${config.home.homeDirectory}/.nix-profile/bin/jellyfinmediaplayer";
    launchOptions = "LD_PRELOAD= %command% --tv --fullscreen";
  };
}
