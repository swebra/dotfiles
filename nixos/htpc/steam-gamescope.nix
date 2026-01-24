{pkgs, ...}: let
  sessionSwitcher = pkgs.writeShellScriptBin "steamos-session-select" ''
    set -x
    ${pkgs.pulseaudio}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/service-logout.oga
    echo "$(date): steamos-session-select called" >> /tmp/steamos-session-select.log
    # sleep 5
    # systemctl stop --user gamescope-session
    steam -shutdown
  '';
in {
  programs = {
    gamescope.capSysNice = true;
    steam = {
      gamescopeSession = {
        enable = true;
        steamArgs = [
          "-tenfoot"
          "-pipewire-dmabuf"
          # "-steamdeck"
          "-steamos3" # Needed for steamos-session-select to be called
        ];
      };

      # https://github.com/Jovian-Experiments/Jovian-NixOS/blob/development/pkgs/steam-jupiter/fhsenv.nix#L30
      # https://linuxcommandlibrary.com/man/steamos-session-select
      # Just make a script and add it here as an extraPackage? Or just generally on the path?
      extraPackages = [
        sessionSwitcher
      ];
    };
  };

  environment.systemPackages = [
    sessionSwitcher
  ];
}
