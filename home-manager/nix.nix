{
  config,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    flake = builtins.toPath "${config.home.homeDirectory}/.dotfiles";
  };

  home.packages = with pkgs; [
    nil
    alejandra
  ];
}
