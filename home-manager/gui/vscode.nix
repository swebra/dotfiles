{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.opt.gui.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
