{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  myOS = {
    machine-name = "build-two";
    gui.enable = true;
    gaming.enable = true;
    dev.docker.enable = true;
    work.enable = true;
  };

  hardware.bluetooth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18; # TODO: Update in 26.05

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "24.11"; # Did you read the comment?
}
