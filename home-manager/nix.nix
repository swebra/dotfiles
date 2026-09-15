{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    flake = config.myHome.dotfilesDir;
  };
  home.sessionVariables.NH_ASK = "1"; # Used in nh release after v4.4.2 (v4.5.X for example)
  # Reference clean example: nh clean all -k 3 -K 2w --keep-one --optimise

  home.packages = with pkgs; [
    nil
    alejandra
  ];
}
