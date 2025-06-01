{
  config,
  pkgs,
  ...
}: let
  # eden = pkgs.appimageTools.wrapType2 {
  #   pname = "eden";
  #   version = "0.0.2";
  #   src = pkgs.fetchurl {
  #     url = "https://github.com/eden-emulator/Releases/releases/download/0.0.2-pre-alpha/Eden-Linux-0.0.2-pre-alpha-amd64.AppImage";
  #     sha256 = "sha256-TNqQzOt/g0PP57hU3W5zuUFa+NowFE53jvm3b3CzH2s=";
  #   };
  # };
  # Eden doesn't seem to work with `appimage-run` nor the appimage wrap function above. Packaging directly instead:
  eden = pkgs.stdenv.mkDerivation rec {
    pname = "eden";
    version = "0.0.2";

    src = pkgs.fetchurl {
      url = "https://github.com/eden-emulator/Releases/releases/download/0.0.2-pre-alpha/Eden-Linux-0.0.2-pre-alpha-amd64.AppImage";
      sha256 = "sha256-TNqQzOt/g0PP57hU3W5zuUFa+NowFE53jvm3b3CzH2s=";
    };

    desktopItem = pkgs.fetchurl {
      # No tagged version yet, using master
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/branch/master/dist/eden.desktop";
      sha256 = "sha256-YNPjNPjtZ6Tk2Pi6bf4d0UAW6WxhB+gcRQx0jJlsvfk=";
    };
    desktopIcon = pkgs.fetchurl {
      url = "https://git.eden-emu.dev/eden-emu/eden/raw/tag/0.0.2-pre-alpha/dist/eden.svg";
      sha256 = "sha256-18Zae6k6C10mANg8rgOpia3zJxnI1Gq3wrKmc/H9jp0=";
    };

    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${pname}
      chmod +x $out/bin/${pname}
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
      cp ${desktopItem} $out/share/applications/eden.desktop
      cp ${desktopIcon} $out/share/icons/hicolor/scalable/apps/eden.svg
    '';
  };
in {
  home.packages = [eden];

  home.file = let
    targetParentDir = ".local/share/eden";
    srcParentDir = "${config.home.homeDirectory}/Games/Emulation";
    mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink "${srcParentDir}/${path}";
  in {
    "${targetParentDir}/keys/".source = mkOutOfStoreSymlink "bios/switch";
    "${targetParentDir}/nand/user/save/".source = mkOutOfStoreSymlink "saves/eden"; # eden-specific

    "${srcParentDir}/manifests/eden.json".text = builtins.toJSON {
      title = "Eden Emulator";
      target = "${config.home.homeDirectory}/.nix-profile/bin/eden";
    };
  };

  # Other files
  # Emulation/otherData/switch/firmware: Installed in emulator with menu, linking seems to cause issues
  # Emulation/otherData/switch/updates: Installed in emulator with menu
  # Emulation/roms/switch: Path configured in emulator
}
