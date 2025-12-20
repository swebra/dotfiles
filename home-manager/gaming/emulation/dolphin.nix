{pkgs, ...}: {
  # https://emudeck.github.io/emulators/steamos/dolphin/
  # https://wiki.retrobat.org/systems-and-emulators/supported-game-systems/game-consoles/nintendo-game-consoles/wii
  # https://wiki.retrobat.org/systems-and-emulators/supported-game-systems/game-consoles/nintendo-game-consoles/gamecube

  home.packages = [pkgs.dolphin-emu];

  # Roms can be targeted directly at
  # ~/Games/Emulation/roms/gc
  # ~/Games/Emulation/roms/wii

  myHome.gaming.emulation.syncPaths = let
    parent = ".local/share/dolphin-emu";
  in {
    "${parent}/Wii/" = "saves/wii";
    "${parent}/GC/" = "saves/gc";

    "${parent}/GameSettings/" = "otherData/dolphin/gameSettings";
  };
}
