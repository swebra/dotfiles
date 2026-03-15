{private, ...}: {
  services.openssh = {
    enable = true;
    ports = [private.server.sshPort];
    # MANUAL SETUP: Authorized keys are manually set (TODO: secret management)
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # TODO: harden, fail2ban, endlessh, etc.
}
