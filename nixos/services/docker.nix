{
  lib,
  config,
  ...
}: {
  options = {
    opt.docker.enable = lib.mkEnableOption "Enables docker support";
  };

  config = lib.mkIf config.opt.docker.enable {
    virtualisation.docker.enable = true;

    users.extraGroups.docker.members = [config.opt.user];
  };
}
