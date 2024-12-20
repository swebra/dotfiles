{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./user.nix
    ./core_programs.nix
    ./services/docker.nix
    ./services/postgres.nix
  ];

  config = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"]; # set primarily for nixd

    docker.enable = lib.mkDefault true;
  };
}
