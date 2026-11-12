{
  pkgs,
  pkgs-unstable,
  ...
}: {
  /*
  https://wiki.hypr.land/useful-utilities/must-have/
  - Notification daemon handled by Noctalia
  - Pipewire declared in system module
  - Desktop portal handled by hyprland module
  - Polkit agent handled by Noctalia (when enabled)
  - Qt Wayland support handled by hyprland module
  --- Other ---
  - Keyring/secret service handled by KWallet, see start up in home config
  */

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = [
    pkgs-unstable.noctalia
    # Temp playing with file managers
    pkgs.gvfs
    # pkgs.gvfs-smb
  ];
  # Temp playing with file managers
  services.gvfs.enable = true;

  # TODO: Double check if needed
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # TODO: Make this Hyprland-specific with systemd-inhibit?
  # See also services.logind.settings.Login.PowerKeyIgnoreInhibited = "no";
  services.logind.settings.Login.HandlePowerKey = "ignore";
}
