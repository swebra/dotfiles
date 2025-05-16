{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.torzu];

  home.file = let
    targetParentDir = ".local/share/yuzu";
    srcParentDir = "${config.home.homeDirectory}/Games/Emulation";
    mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink "${srcParentDir}/${path}";
  in {
    "${targetParentDir}/keys/".source = mkOutOfStoreSymlink "bios/switch/keys";
    "${targetParentDir}/nand/system/Contents/registered/".source = mkOutOfStoreSymlink "bios/switch/firmware";
    "${targetParentDir}/nand/user/save/".source = mkOutOfStoreSymlink "saves/yuzu";

    "${srcParentDir}/roms/manifests/torzu.json".text = builtins.toJSON {
      title = "Torzu";
      target = "${config.home.homeDirectory}/.nix-profile/bin/yuzu";
      # launchOptions = "LD_PRELOAD= %command% --tv --fullscreen";
    };
  };

  # Other files
  # Emulation/roms/switch: Path configured in emulator
  # Emulation/otherData/switch/updates: Updates are installed in emulator

  # TODO: Activation script to create these dirs? Or validate that the symlinks aren't broken?
}
