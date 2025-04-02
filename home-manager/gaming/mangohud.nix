{...}: {
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;

    settings = {
      gpu_stats = true;
      gpu_temp = true;
      cpu_stats = true;
      cpu_temp = true;
      ram = true;

      horizontal = true;
      horizontal_stretch = false;
      hud_no_margin = true;
      font_size = 18;
    };
  };
}
