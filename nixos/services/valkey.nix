{pkgs, ...}: {
  # See https://github.com/NixOS/nixpkgs/pull/315557 for upcoming changes
  services.redis = {
    package = pkgs.valkey;
    servers.valkey.enable = true;
  };
}
