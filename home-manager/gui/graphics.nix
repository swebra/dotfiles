{pkgs, ...}: {
  home.packages = with pkgs; [
    imagemagick
    inkscape
    gimp
  ];
}
