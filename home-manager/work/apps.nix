{pkgs, ...}: {
  home.packages = with pkgs; [
    slack
    libreoffice-qt # or libreoffice
    onlyoffice-desktopeditors # just trialing
  ];
}
