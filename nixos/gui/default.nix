{lib, ...}: {
  imports = [
    ./fonts.nix
  ];

  options = {
    opt.gui.enable = lib.mkEnableOption "Enable graphical program configuration";
  };
}
