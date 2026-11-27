{
  pkgs,
  pkgs-unstable,
  inputs,
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
    pkgs.wl-clipboard
  ];

  # Luciole file manager
  imports = [inputs.luciole.nixosModules.default];
  services.gvfs.enable = true; # For trash, network support
  services.avahi.enable = true; # DNS discovery
  programs.luciole.enable = true;
  xdg.portal = {
    extraPortals = [inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default];
    config.common."org.freedesktop.impl.portal.FileChooser" = ["luciole" "gtk"];
  };

  # TODO: Double check if needed
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # TODO: Make this Hyprland-specific with systemd-inhibit?
  # See also services.logind.settings.Login.PowerKeyIgnoreInhibited = "no";
  services.logind.settings.Login.HandlePowerKey = "ignore";
}
