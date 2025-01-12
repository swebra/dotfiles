{lib, ...}: {
  imports = [
    ./alacritty.nix
    ./vscode.nix
    ./zen-browser.nix
  ];

  options = {
    opt.gui.enable = lib.mkEnableOption "Enable graphical program configuration";
  };
}
