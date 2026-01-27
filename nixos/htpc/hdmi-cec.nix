{
  lib,
  pkgs,
  ...
}: {
  # Systemd services for HDMI-CEC control of TV
  # References:
  # https://github.com/Pulse-Eight/libcec/tree/master/systemd
  # https://github.com/josephbreiting/cec-systemd/
  # https://github.com/Lawstorant/cec-toolbox/tree/main/systemd

  # libcec is used directly for simplicity as cec-ctl requires the adapter's "line
  # discipline" to be configured to create a /dev/cecX device
  # https://wiki.archlinux.org/title/HDMI-CEC#PulseEight_USB_adapter

  # Nix systemd options (script/preStop) give full shell support (piping, &&, etc)

  systemd = let
    cec-client = cmd: "echo '${cmd}' | ${lib.getExe' pkgs.libcec "cec-client"} --log-level 4 --single-command";
    cec-on = cec-client "on 0" + " && sleep 4 && " + cec-client "as"; # Power and input
    cec-off = cec-client "standby 0";
  in {
    # Boot timer is slightly faster than waiting for multi-user.target
    timers.cec-on-boot = {
      description = "Trigger cec-on-boot service on boot";
      timerConfig.OnBootSec = 1;
      wantedBy = ["timers.target"];
    };

    services = {
      cec-on-boot = {
        description = "Turn On TV and Set HDMI Input";
        serviceConfig.Type = "oneshot";
        script = cec-on;
      };

      # Dependency on poweroff.target/shutdown.target didn't work reliably, so this is
      # catching the stop of multi-user.target instead
      cec-power = {
        description = "Turn Off TV";
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes"; # Stay "running/active" after (no-op) script completes
        };
        preStop = cec-off; # ExecStop
      };

      cec-sleep = {
        description = "Turn Off TV on Sleep, Turn On TV on Wake";
        wantedBy = ["sleep.target"];
        before = ["sleep.target"]; # Run script before sleep
        unitConfig.StopWhenUnneeded = "yes"; # Stop when sleep.target has ended, running preStop
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes"; # Stay "running/active" after script completes
        };
        script = cec-off;
        preStop = cec-on;
      };
    };
  };
}
