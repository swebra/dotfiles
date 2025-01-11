{lib, ...}: {
  imports = [
    ./controllers.nix
    ./steam.nix
  ];

  options = {
    opt.gaming.enable = lib.mkEnableOption "Enable gaming programs";
  };
}
