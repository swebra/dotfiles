{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  config = lib.mkIf config.opt.gui.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };
}
