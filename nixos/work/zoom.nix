{pkgs-unstable, ...}: {
  programs.zoom-us = {
    enable = true;
    package = pkgs-unstable.zoom-us;
  };
}
