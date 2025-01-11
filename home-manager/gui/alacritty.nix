{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.opt.gui.enable {
    programs.alacritty = {
      enable = true;
    };
  };
}
