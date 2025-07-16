{...}: {
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };
}
