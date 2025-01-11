{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.opt.gaming.enable {
    # Support Xbox One wireless adapter
    hardware.xone.enable = true;
  };
}
