{pkgs, ...}: {
  # steam-hardware (for Steam Controller) already enabled by steam itself

  # Support Xbox One wireless adapter
  hardware.xone.enable = true;

  # Support dolphinbar and gamecube adapter (not automatic when installing through home-manager)
  services.udev.packages = [pkgs.dolphin-emu];
}
