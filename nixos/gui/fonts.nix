{pkgs, ...}: {
  fonts.packages = with pkgs; [
    # TODO: Change to `nerds-fonts.meslo-lg` in 25.05
    (nerdfonts.override {fonts = ["Meslo"];})
  ];
}
