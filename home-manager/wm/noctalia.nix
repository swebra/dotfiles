{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    myHome.wm.mobile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether the device is mobile with a battery (i.e. a laptop)";
    };
  };

  config = {
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
        templates.builtin_ids = ["hyprland" "luciole"];
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
          art_size = 96; # Take up all available space
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

      /*
      Timeout time is global across all behaviors (not cumulative between behaviors) and
      is expected to match behavior_order.

      Generally* the fade is triggered at the first timeout and effectively delays all
      actions until the fade is complete, e.g. fade of 10s with a 20s screen off and 50s
      suspend will result in the screen being fully off at 30s and system sleeping at
      60s.

      *From testing, there seems to be an edge case where the delay is ignored if a
      secondary behavior timeout lines up with a delayed first behavior action, e.g. a
      fade of 10s with a 20s screen off and 30s suspend will result in the screen being
      fully off at 30s and the system immediately sleeping rather than the sleep being
      delayed until 40s.
      */
      idle = let
        fade_time = 15;
        timeout_start =
          (
            if config.myHome.wm.mobile
            then 2 # minutes
            else 15 # minutes
          )
          * 60;
      in {
        pre_action_fade_seconds = fade_time;
        behavior_order = ["screen-off" "lock" "suspend"];
        behavior = {
          screen-off = {
            action = "screen_off";
            timeout = timeout_start - fade_time;
          };
          lock = {
            action = "lock";
            timeout = timeout_start * 2 - fade_time;
          };
          suspend = {
            action = "suspend";
            timeout = timeout_start * 4 - fade_time;
          };
        };
      };

      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
      };
    };
  };
}
