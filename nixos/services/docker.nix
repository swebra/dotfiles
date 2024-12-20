{
  lib,
  config,
  ...
}: {
  options = {
    docker.enable = lib.mkEnableOption "Enables docker support";
  };

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;

    # TODO: Reference user
    users.extraGroups.docker.members = [config.user];
  };
}
