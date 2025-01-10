{lib, ...}: {
  imports = [
    ./aws.nix
  ];

  options = {
    opt.work-dev.enable = lib.mkEnableOption "Enable work-specific development configuration";
  };
}
