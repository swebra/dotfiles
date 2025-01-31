{
  config,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    flake = config.myHome.dotfilesDir;
  };

  home.packages = with pkgs; [
    nil
    alejandra
  ];
}
