{pkgs-unstable, ...}:
/*
https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/programs/zoom-us.nix
https://wiki.archlinux.org/title/Zoom_Meetings
*/
{
  programs.zoom-us = {
    enable = true;
    package = pkgs-unstable.zoom-us;
  };
}
