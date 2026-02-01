{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  myOS = {
    machine-name = "build-two";
    gui.enable = true;
    gaming.enable = true;
    dev.docker.enable = true;
  };

  hardware.bluetooth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "24.11"; # Did you read the comment?
}
