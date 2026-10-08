{
  lib,
  pkgs,
  ...
}: {
  /*
  - https://github.com/goweiwen/silverbullet-plus-flake/blob/main/flake.nix

  TODO: When updating to 2.12
  - Download from new URL (https://silverbullet.md/desktop/download)
  - Make sure it works with the move to electron
  */
  home.packages = let
    pname = "silverbullet-plus";
    version = "2.11.1";

    src = pkgs.fetchurl {
      url = "https://releases.silverbullet.plus/releases/${version}/SilverBullet_x86_64.AppImage";
      hash = "sha256-7YQ0GId03Qfzd6Au60jC3z3mm5NZi2bQTto7bL5PF58=";
    };

    extracted = pkgs.appimageTools.extractType2 {inherit pname version src;};

    silverbullet-plus = pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -Dm444 ${extracted}/usr/share/applications/SilverBullet.desktop \
          $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=silverbullet-app' 'Exec=${pname}'
        install -Dm444 ${extracted}/usr/share/icons/hicolor/1024x1024/apps/silverbullet-app.png \
          $out/share/icons/hicolor/1024x1024/apps/silverbullet-app.png
      '';

      meta = {
        license = lib.licenses.unfree;
        mainProgram = pname;
      };
    };
  in [
    silverbullet-plus
  ];
}
