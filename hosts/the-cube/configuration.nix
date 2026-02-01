{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  myOS = {
    machine-name = "the-cube";
    gui.enable = true;
    gaming.enable = true;
    htpc.enable = true;
  };

  # For remote management
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  hardware.bluetooth.enable = true;

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "25.05"; # Did you read the comment?
}
