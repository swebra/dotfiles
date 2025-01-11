{lib, ...}: {
  imports = [
    ./alacritty.nix
    ./vscode.nix
  ];

  options = {
    opt.gui.enable = lib.mkEnableOption "Enable graphical program configuration";
  };
}
