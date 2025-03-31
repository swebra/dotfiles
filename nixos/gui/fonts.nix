{
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    # TODO: Cleanup after moving everthing to 25.05
    (
      if (lib.trivial.release == "24.11")
      then (nerdfonts.override {fonts = ["Meslo"];})
      else nerd-fonts.meslo-lg
    )
  ];
}
