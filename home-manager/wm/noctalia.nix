{pkgs, ...}: {
  # TODO: Use built-in home-manager configuration when it's available
  xdg.configFile."noctalia/config.toml".source = (pkgs.formats.toml {}).generate "noctalia-config" {
    shell.settings_show_advanced = true;
  };
}
