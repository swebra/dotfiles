{config, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  myOS = {
    machine-name = "xps9575";
    gui.enable = true;
    gaming.enable = true;
  };

  hardware.bluetooth.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = config.myOS.user;

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "23.11"; # Did you read the comment?
}
