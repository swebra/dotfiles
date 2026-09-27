{pkgs, ...}: {
  home.packages = let
    pname = "silverbullet-plus";
    version = "2.11.0";

    src = pkgs.fetchurl {
      url = "https://releases.silverbullet.plus/releases/${version}/SilverBullet_x86_64.AppImage";
      hash = "sha256-7YQ0GId03Qfzd6Au60jC3z3mm5NZi2bQTto7bL5PF58=";
    };

    silverbullet-plus = pkgs.appimageTools.wrapType2 {inherit pname version src;};
  in [
    silverbullet-plus
  ];
}
