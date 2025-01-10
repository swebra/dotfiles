{...}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;

    nix-direnv.enable = true;
  };

  programs.git.ignores = [
    ".direnv"
    ".envrc"
  ];
}
