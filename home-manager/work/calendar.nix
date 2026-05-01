{
  lib,
  pkgs,
  ...
}: {
  # MANUAL SETUP: Google calendar API client token is manually set (TODO: secret management)
  # Stored in `.local/share/gcalcli`

  home.packages = with pkgs; [
    gcalcli
  ];

  systemd.user = let
    serviceName = "gcalcli-remind";
  in {
    services.${serviceName} = {
      Unit = {
        Description = "Show notifications for upcoming calendar events";
        After = ["network-online.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.gcalcli} remind";
      };
    };

    timers.${serviceName} = {
      Unit.Description = "Check calendar for upcoming events";
      Timer = {
        OnCalendar = "*:0/5"; # Every 5 minutes
        Persistent = true; # Handle last "missed" event (for example when computer off)
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
