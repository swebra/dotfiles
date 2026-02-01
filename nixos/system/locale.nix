{...}: {
  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalization properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
