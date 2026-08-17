{
  lib,
  pkgs,
  ...
}:
/*
- https://github.com/timrogers/litra-autotoggle
- Based on https://github.com/NixOS/nixpkgs/pull/408988

litra-rs just provides CLI control roughly equivalent to the physical buttons, so it is
omitted here.
*/
let
  litra-autotoggle = pkgs.rustPackages.rustPlatform.buildRustPackage rec {
    pname = "litra-autotoggle";
    version = "1.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "timrogers";
      repo = "litra-autotoggle";
      tag = "v${version}";
      hash = "sha256-fx3j3LIdiSqnsNb66BRzz/q1qlLbPsfrtfKFKesJw0k=";
    };

    cargoHash = "sha256-jCLUdPUGdhFTysKLCqE1JGfUVzzDdvQDFPnelyQcDSY=";

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.udev
    ];

    postInstall = ''
      mkdir -p $out/etc/udev/rules.d
      cp *.rules $out/etc/udev/rules.d
    '';

    meta.mainProgram = "litra-autotoggle";
  };
in {
  environment.systemPackages = [
    litra-autotoggle
  ];

  services.udev.packages = [
    litra-autotoggle
  ];

  systemd.services.litra-autotoggle = {
    description = "Turn your Logitech Litra device on when your webcam turns on";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5";
      ExecStart = "${lib.getExe litra-autotoggle} --delay 1000";
    };
  };
}
