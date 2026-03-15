{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    # TODO: Update in 26.05
    package = pkgs-unstable.nh;
    flake = config.myHome.dotfilesDir;
  };

  home.packages = with pkgs; [
    nil
    alejandra
  ];
}
