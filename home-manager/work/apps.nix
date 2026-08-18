{pkgs, ...}: {
  home.packages = with pkgs; [
    slack
    libreoffice # I don't love the QT breeze styling with libreoffice-qt
  ];

  programs.onlyoffice.enable = true;
  /*
  Onlyoffice has font issues (https://github.com/ONLYOFFICE/DocumentServer/issues/1859)

  Work around below based on
  - https://github.com/ONLYOFFICE/DocumentServer/issues/1859#issuecomment-4484049376
  - https://github.com/NixOS/nixpkgs/issues/373521#issuecomment-2588283507

  Native work around to come in https://github.com/NixOS/nixpkgs/pull/526315
  */
  home.activation.copy-fonts-local-share = ''
    mkdir -p ~/.local/share/fonts
    cp -u ${pkgs.corefonts}/share/fonts/truetype/* ~/.local/share/fonts/
    cp -u ${pkgs.vista-fonts}/share/fonts/truetype/* ~/.local/share/fonts/
    chmod 544 ~/.local/share/fonts
    chmod 444 ~/.local/share/fonts/*
  '';
}
