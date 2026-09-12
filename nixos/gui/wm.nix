{pkgs-unstable, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.systemPackages = [pkgs-unstable.noctalia];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # TODO: Make this Hyprland-specific with systemd-inhibit?
  # See also services.logind.settings.Login.PowerKeyIgnoreInhibited = "no";
  services.logind.settings.Login.HandlePowerKey = "ignore";
}
