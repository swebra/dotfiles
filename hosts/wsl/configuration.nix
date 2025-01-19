{
  inputs,
  config,
  ...
}: {
  imports = [
    ../../nixos
    inputs.nixos-wsl.nixosModules.default
  ];

  myOS = {
    services.docker.enable = true;
    services.postgres.enable = true;
  };

  # WSL support
  wsl.enable = true;
  wsl.defaultUser = config.opt.user;
  networking.hostName = "wsl";

  # Provide libraries for VSCode remote
  # https://nix-community.github.io/NixOS-WSL/how-to/vscode.html#option-1-set-up-nix-ld
  programs.nix-ld = {
    enable = true;
  };

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "23.11"; # Did you read the comment?
}
