{
  inputs,
  pkgs,
  ...
}: {
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

  # Hardware acceleration
  # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
  # https://wiki.nixos.org/wiki/Intel_Graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime # OpenCL
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};

  # Do not update for new release cycle, see NixOS docs
  system.stateVersion = "25.05"; # Did you read the comment?
}
