{config, ...}: {
  virtualisation.docker.enable = true;

  users.extraGroups.docker.members = [config.myOS.user];
}
