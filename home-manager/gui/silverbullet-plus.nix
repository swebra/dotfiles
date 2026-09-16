{pkgs, ...}: {
  home.packages = let
    pname = "silverbullet-plus";
    version = "2.10.0";

    src = pkgs.fetchurl {
      url = "https://releases.silverbullet.plus/releases/${version}/SilverBullet_x86_64.AppImage";
      hash = "sha256-dgqQOkxKIlRE/sLUfWLDELAoFK9tvVbkvzqApJuCtFw=";
    };

    silverbullet-plus = pkgs.appimageTools.wrapType2 {inherit pname version src;};
  in [
    silverbullet-plus
  ];
}
