{
  lib,
  pkgs,
  ...
}:
/*
- https://github.com/timrogers/litra-rs
- https://github.com/timrogers/litra-autotoggle
- Based on https://github.com/NixOS/nixpkgs/pull/408988
*/
let
  litra = pkgs.rustPlatform.buildRustPackage rec {
    pname = "litra";
    version = "3.3.0";

    src = pkgs.fetchFromGitHub {
      owner = "timrogers";
      repo = "litra-rs";
      tag = "v${version}";
      hash = "sha256-cd6fg1rH7ZkUmYfdQoVQsypJgGwkvpmCvPrRpduMxSg=";
    };
    cargoHash = "sha256-Y7H448hG0/I7Ym6U+oX17XWTnVPW7ZA9l2w4fys6IhU=";

    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.udev];

    postInstall = ''
      mkdir -p $out/etc/udev/rules.d
      cp *.rules $out/etc/udev/rules.d
    '';

    meta.mainProgram = "litra";
  };

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

    nativeBuildInputs = [pkgs.pkg-config];

    buildInputs = [pkgs.udev];

    postInstall = ''
      mkdir -p $out/etc/udev/rules.d
      cp *.rules $out/etc/udev/rules.d
    '';

    meta.mainProgram = "litra-autotoggle";
  };

  frontSerial = "2232FE601HF8";
  biasSerial = "2232FE600UD8";
in {
  environment.systemPackages = [
    litra
    litra-autotoggle
  ];

  services.udev.packages = [
    litra
    litra-autotoggle
  ];

  systemd.services.litra-autotoggle = {
    description = "Turns on front Logitech Litra when webcam turns on";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5";
      ExecStart = "${lib.getExe litra-autotoggle} --delay 1000 -s ${frontSerial}";
    };
  };

  # TODO: Service for bias light to follow sleep
}
