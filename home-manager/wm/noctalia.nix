{
  config,
  pkgs,
  ...
}: {
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
    theme = {
      source = "wallpaper";
      templates.builtin_ids = ["hyprland"];
    };
    wallpaper = {
      directory = "${config.xdg.userDirs.pictures}/dorianlegret";
      automation.enabled = true;
      transition_on_startup = true;
    };
    bar.default = {
      capsule = true;
      background_opacity = 0.5;
      margin_ends = 5;
      padding = 5;
    };
    shell.panel.transparency_mode = "solid";
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
      active_window = {
        display = "text_only";
        min_length = 10;
      };
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
        hide_when_idle = true;
        art_size = 100; # Take up all available space
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
    shell.panel.open_near_click_control_center = true;
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
    calendar = {
      enabled = true;
      account.work = {
        name = "Work";
        type = "google";
      };
      reminders = false;
    };

    # Other modal config
    shell = {
      polkit_agent = true;
      launcher = {
        layout = "simple";
        compact = true;
        category_icons_only = true;
        providers.session.global = true;
      };
      screenshot = {
        annotate = true;
        save_to_file = false;
        close_on_copy = false;
        close_on_save = false;
      };
      panel.wallpaper_show_names = false;
    };

    osd.kinds = {
      volume_input = false; # Hide mic volume auto-adjust by things like discord, zoom, etc.
      media = false; # Have media widget instead to show track name
    };

    notification.filter = {
      network = {
        match = "Network Management";
        save_history = false;
      };
      slack = {
        match = "Slack";
        save_history = false;
        play_sound = false;
      };
      discord = {
        match = "Discord";
        save_history = false;
        play_sound = false;
      };
    };

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
      fade_time = 10;
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
