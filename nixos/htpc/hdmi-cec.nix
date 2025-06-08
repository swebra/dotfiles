{
  lib,
  pkgs,
  ...
}: let
  # TODO: echo from coreutils specifically?
  cec-client = cmd: "echo '${cmd}' | ${lib.getExe' pkgs.libcec "cec-client"} -s";
in {
  # https://github.com/Pulse-Eight/libcec/tree/master/systemd
  # https://github.com/josephbreiting/cec-systemd/
  # https://github.com/NixOS/nixpkgs/blob/c736ff24eb207acb0d415be67edc7f9656ad2844/nixos/lib/systemd-unit-options.nix

  # Might be more that can be done https://wiki.archlinux.org/title/HDMI-CEC

  # systemctl cat <service-name> to see the full output service file

  # Use nix options instead of directly to get access to "full" shell with piping support
  # Could also ExecStart=/bin/sh -c

  systemd = {
    timers.cec-boot = {
      description = "Trigger cec-boot service on boot";
      timerConfig = {
        OnBootSec = 1;
        OnStartupSec = 1;
      };
      wantedBy = ["timers.target"];
    };

    services = {
      cec-boot = {
        description = "Turns on TV and sets the input";
        serviceConfig.Type = "oneshot";
        preStart = cec-client "on 0"; # ExecStartPre
        script = cec-client "as 0"; # ExecStart
      };

      cec-poweroff = {
        description = "Turns off TV on shutdown";
        serviceConfig.Type = "oneshot";
        # idk why both
        script = cec-client "standby 0"; # ExecStart
        preStop = cec-client "standby 0"; # ExecStop
        wantedBy = ["poweroff.target"];
      };
    };
  };
}
