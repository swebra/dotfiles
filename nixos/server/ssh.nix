{private, ...}: {
  services.openssh = {
    enable = true;
    ports = [private.server.sshPort];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # TODO: harden, fail2ban, endlessh, etc.
}
