{pkgs, ...}: {
  # TODO: Use built-in home-manager configuration when it's available

  # See .local/state/noctalia/config.toml for the GUI config reference
  # https://docs.noctalia.dev/noctalia/configuration/

  xdg.configFile."noctalia/config.toml".source = (pkgs.formats.toml {}).generate "noctalia-config" {
    # General
    shell = {
      settings_show_advanced = true;
      telemetry_enabled = true;
      time_format = "{:%I:%M %p}";
    };

    # Theming
    theme.source = "wallpaper";
    wallpaper = {
      automation.enabled = true;
      transition_on_startup = true;
    };
    bar.default = {
      capsule = true;
      background_opacity = 0.95;
      margin_ends = 10;
    };
    panel.transparency_mode = "solid";
    osd.background_opacity = 90;

    # Bar
    bar.default = {
      capsule_group = [
        {
          id = "system_tray";
          members = ["tray" "privacy" "volume" "bluetooth" "network" "battery"];
        }
        {
          id = "system_monitor";
          members = ["cpu" "ram"];
        }
      ];

      start = ["workspaces" "active_window"];
      center = ["date" "clock" "weather"];
      end = ["media" "notifications" "group:system_tray"];
    };

    widget = let
      iso_format = "%F %H:%M:%S %z";
    in {
      active_window.display = "text_only";
      clock = {
        anchor = true;
        format = "%I:%M %p";
        tooltip_format = iso_format;
        actions.left = "panel-toggle control-center";
      };
      cpu.visualization = "none";
      date = {
        format = "%a, %b %d";
        tooltip_format = iso_format;
      };
      media = {
        show_progress = true;
        hide_when_no_media = true;
      };
      network.show_label = false;
      privacy = {
        hide_inactive = true;
        active_color = "on_surface"; # Match color of other system tray items
      };
      ram = {
        stat = "ram_pct";
        visualization = "none";
      };
      volume.show_label = false;
    };

    # Control center
    panel.open_near_click_control_center = true;
    control_center = {
      hidden_tabs = ["monitor"];
      shortcuts = [
        {type = "notification";}
        {type = "power_profile";}
        {type = "caffeine";}
        {type = "nightlight";}
        {type = "dark_mode";}
        {type = "wallpaper";}
      ];
    };
    location.auto_locate = true; # For weather tab

    # Other modal config
    shell = {
      launcher = {
        compact = true;
        providers.session.global = true;
      };
      screenshot.save_to_file = false;
    };
    osd.kinds.media = false;

    # Power + lock
    shell.session.actions = [
      {action = "lock";}
      {
        action = "lock_and_suspend";
        label = "Sleep";
        glyph = "moon";
      }
      {action = "logout";}
      {
        action = "reboot";
        countdown_seconds = 5.0;
      }
      {
        action = "shutdown";
        variant = "destructive";
        countdown_seconds = 5.0;
      }
    ];

    # TODO: Figure out the mechanism here, the timeout options seem to have weird
    # behavior, unclear if they are global timers or after-last-behavior.
    idle = let
      fade_time = 5;
    in {
      pre_action_fade_seconds = fade_time;
      behavior_order = ["lock" "screen-off" "lock-and-suspend"];
      behavior = {
        lock = {
          action = "lock";
          timeout = 120 - fade_time;
        };
        screen-off = {
          action = "screen_off";
          locked_timeout = 15; # How long after the screen is locked.
          timeout = 200; # This is time after lock
        };
        lock-and-suspend = {
          action = "lock_and_suspend";
          timeout = 300;
        };
      };
    };

    lockscreen = {
      enabled = true;
      lock_before_suspend = true;
    };
  };
}
