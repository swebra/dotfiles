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
    # Overlay to fix bwrap issue with capSysNice in gamescope. See
    # https://github.com/NixOS/nixpkgs/pull/524488#issuecomment-4558298012, and also
    # https://github.com/NixOS/nixpkgs/issues/523427 for the original issue.
    nixpkgs.overlays = [
      (final: prev: {
        gamescope = prev.gamescope.overrideAttrs (oa: {
          postPatch =
            (oa.postPatch or "")
            + ''
              substituteInPlace src/Utils/Process.cpp \
                --replace-fail 'RestoreFdLimit();' 'prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_LOWER, 23, 0, 0); RestoreFdLimit();'
            '';
        });
      })
    ];

    programs = {
      gamescope.capSysNice = true;
      steam = {
        gamescopeSession = {
          enable = true;
          args = ["--mangoapp"]; # Gamescope performance overlay

          steamArgs = [
            "-tenfoot" # Big Picture mode
            "-pipewire-dmabuf" # Default option
            "-steamos3" # Needed for steamos-session-select to be called
            # "-steamdeck"
          ];
        };

        extraPackages = [
          # Called by Steam when "switching to desktop mode"
          # https://github.com/Jovian-Experiments/Jovian-NixOS/blob/20d5e9195eee6692afe9186a9d45c79ba7aad56a/pkgs/steam-jupiter/fhsenv.nix#L30
          # https://github.com/ChimeraOS/gamescope-session-steam/blob/main/usr/bin/steamos-session-select
          # WARN: This now looks to be depreciated for steamosctl, jovian has since
          # moved over but maintains a stub:
          # https://github.com/Jovian-Experiments/Jovian-NixOS/commit/52f140c07493f8bb6cd0773c7e1afe3e1fd1d1fa
          # https://github.com/Jovian-Experiments/Jovian-NixOS/commit/31f540444f8a32555cf88260d660c9f4afe27bbb
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

    # For performance overlay
    environment.systemPackages = [pkgs.mangohud];
  };
}
