{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
  ];

  myOS = {
    machine-name = "fw13pro";
    gui.enable = true;
    dev.enable = true;
    gaming.enable = true;
    work.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.printing.enable = true;

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "26.05"; # Did you read the comment?
}
