{pkgs, ...}: {
  services.redis = {
    enable = true;
    package = pkgs.valkey;
  };
}
