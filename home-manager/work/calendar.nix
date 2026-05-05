{
  lib,
  pkgs,
  ...
}: {
  # MANUAL SETUP: Google calendar API client token is manually set (TODO: secret management)
  # Stored in `.local/share/gcalcli`

  home.packages = [
    pkgs.gcalcli
  ];

  systemd.user = let
    serviceName = "calendar-remind";

    calendar-remind-bin =
      pkgs.writers.writePython3 "calendar-remind" {
        makeWrapperArgs = ["--prefix" "PATH" ":" "${lib.makeBinPath (with pkgs; [gcalcli libnotify])}"];
        flakeIgnore = ["E501"];
      }
      ./calendar-remind.py;
  in {
    services.${serviceName} = {
      Unit = {
        Description = "Show notifications for upcoming calendar events";
        After = ["network-online.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "oneshot";
        ExecStart = calendar-remind-bin;
        # Don't kill subprocesses (the button handling) when main process exits
        KillMode = "process";
      };
    };

    timers.${serviceName} = {
      Unit.Description = "Check calendar for upcoming events";
      Timer = {
        # Around work hours, every 5n-1 minutes (07:04, 07:09, ..., 17:54, 17:59)
        OnCalendar = "Mon..Fri 07..17:4/5";
        AccuracySec = "15s"; # Within 15 seconds of above ^ (default is 1 min)
        Persistent = true; # Handle last "missed" event (for example when computer off)
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
