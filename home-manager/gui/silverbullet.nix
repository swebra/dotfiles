{
  lib,
  pkgs,
  ...
}: {
  /*
  - https://github.com/goweiwen/silverbullet-plus-flake/blob/main/flake.nix
  */
  home.packages = let
    pname = "silverbullet";
    version = "2.12.1";

    src = pkgs.fetchurl {
      url = "https://release.silverbullet.md/electron/artifacts/${version}/linux/x64/SilverBullet-${version}-linux-x86_64.AppImage";
      hash = "sha256-cg6PDGRxi+NNGX4CJGnBX+/wuSXJ/8vP3wboWjONd28=";
    };

    extracted = pkgs.appimageTools.extractType2 {inherit pname version src;};

    silverbullet = pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -Dm444 ${extracted}/silverbullet.desktop \
          $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}'
        install -Dm444 ${extracted}/usr/share/icons/hicolor/512x512/apps/silverbullet.png \
          $out/share/icons/hicolor/512x512/apps/silverbullet.png
      '';

      meta = {
        license = lib.licenses.unfree;
        mainProgram = pname;
      };
    };
  in [
    silverbullet
  ];
}
