{pkgs, ...}: {
  # Support Xbox One wireless adapter
  hardware.xone.enable = true;

  # Support dolphinbar and gamecube adapter
  services.udev.packages = [pkgs.dolphin-emu];
}
