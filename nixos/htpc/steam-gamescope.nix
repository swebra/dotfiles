{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    myOS.htpc.steamGamescope.autoLogin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable auto-login into the Steam gamescope session.
      '';
    };
  };

  config = {
    programs = {
      gamescope.capSysNice = true;
      steam = {
        gamescopeSession = {
          enable = true;
          steamArgs = [
            "-tenfoot" # Big Picture mode
            "-pipewire-dmabuf" # Default option
            "-steamos3" # Needed for steamos-session-select to be called
            # "-steamdeck"
          ];
        };

        extraPackages = [
          # Called by Steam when "switching to desktop mode"
          # https://github.com/Jovian-Experiments/Jovian-NixOS/blob/development/pkgs/steam-jupiter/fhsenv.nix#L30
          # https://github.com/ChimeraOS/gamescope-session-steam/blob/main/usr/bin/steamos-session-select
          (pkgs.writeShellScriptBin "steamos-session-select" ''
            echo "Shutting down gamescope session from custom steamos-session-select"
            # Not currently using proper session, https://github.com/NixOS/nixpkgs/issues/419121
            # systemctl stop --user gamescope-session
            steam -shutdown
          '')
        ];
      };
    };

    services.displayManager = lib.mkIf config.myOS.htpc.steamGamescope.autoLogin {
      defaultSession = "steam";
      autoLogin = {
        enable = true;
        user = config.myOS.user;
      };
    };
  };
}
