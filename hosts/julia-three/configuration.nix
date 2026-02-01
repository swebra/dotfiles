{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.vscode-server.nixosModules.default # vscode server
  ];

  myOS = {
    machine-name = "julia-three";
    user = "julia";
    system.audio.enable = false;
    server.enable = true;
  };

  services.vscode-server.enable = true;

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "25.05"; # Did you read the comment?
}
