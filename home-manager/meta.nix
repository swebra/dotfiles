{
  config,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    flake = builtins.toPath "${config.home.homeDirectory}/.dotfiles";
  };

  home.packages = with pkgs; [
    nil
    alejandra
  ];
}
