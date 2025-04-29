{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    steam-rom-manager
  ];

  # TODO: Generate from options? SRM logs errors when read only file, but might be fine anyways
  # Current configuration is user-specific
  xdg.configFile."steam-rom-manager/userData/userConfigurations.json".source = let
    parentDir = "${config.myHome.dotfilesDir}/home-manager/htpc";
    mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink "${parentDir}/${path}";
  in
    mkOutOfStoreSymlink "steam-rom-manager-config.json";

  # TODO: Activation script to run SRM?
  # https://github.com/SteamGridDB/steam-rom-manager/wiki/Command-Line-Interface
}
