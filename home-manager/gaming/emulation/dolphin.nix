{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.dolphin-emu];

  # TODO: Setup paths

  # Roms:
  # ~/Games/Emulation/roms/gc
  # ~/Games/Emulation/roms/wii

  # /home/eric/.local/share/dolphin-emu/Wii/

  # TODO: Direction of symlink

  # xdg.configFile = let
  #   parentDir = "${config.myHome.dotfilesDir}/home-manager/dev";
  #   mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink "${parentDir}/${path}";
  # in {
  #   "Code/User/settings.json".source = mkOutOfStoreSymlink "vscode-config/settings.jsonc";
  #   "Code/User/keybindings.json".source = mkOutOfStoreSymlink "vscode-config/keybindings.jsonc";
  # };
}
