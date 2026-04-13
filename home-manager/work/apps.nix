{pkgs, ...}: {
  home.packages = with pkgs; [
    slack

    # TODO: Use NixOS option?
    zoom-us
  ];
}
