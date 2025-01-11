{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.opt.gui.enable {
    fonts.packages = with pkgs; [
      # TODO: Change to following in 25.05
      # nerds-fonts.meslo-lg
      (nerdfonts.override {fonts = ["Meslo"];})
    ];
  };
}
