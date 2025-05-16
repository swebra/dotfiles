{pkgs, ...}: {
  # https://github.com/Pulse-Eight/libcec/tree/master/systemd
  systemd.services = {
    cec-poweron = {
      description = "Power on TV on startup";
      script = "${pkgs.echo}/bin/echo 'on 0' | ${pkgs.libcec}/bin/cec-client -s";
      #   serviceConfig = {
      #     Type = "oneshot";
      #     ExecStart = "/bin/echo 'standby 0' | /usr/bin/cec-client -s";
      #     ExecStop = "/bin/echo 'standby 0' | /usr/bin/cec-client -s";
      #   };
      #   wantedBy = ["poweroff.target"];
    };
    # cec-poweroff = {
    #   description = "Power off TV on ___";
    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = "/bin/echo 'standby 0' | /usr/bin/cec-client -s";
    #     ExecStop = "/bin/echo 'standby 0' | /usr/bin/cec-client -s";
    #   };
    #   wantedBy = ["poweroff.target"];
    # };
  };

  # Might be more that can be done https://wiki.archlinux.org/title/HDMI-CEC
}
