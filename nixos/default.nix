{lib, ...}: {
  imports = [
    ./user.nix
    ./core_programs.nix
    ./services/docker.nix
    ./services/postgres.nix
    ./gui
    ./gaming
  ];

  config = {
    nix.settings.experimental-features = ["nix-command" "flakes"];

    opt.docker.enable = lib.mkDefault true;
  };
}
