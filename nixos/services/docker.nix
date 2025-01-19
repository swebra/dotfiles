{config, ...}: {
  virtualisation.docker.enable = true;

  users.extraGroups.docker.members = [config.opt.user];
}
