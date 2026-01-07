{
  config,
  lib,
  ...
}: {
  options = {
    myHome.gaming.emulation = {
      basePath = lib.mkOption {
        type = lib.types.str;
        description = "Base path for emulation-related files.";
        default = "${config.home.homeDirectory}/Games/Emulation";
      };

      syncPaths = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = ''
          Attribute set mapping of emulator paths to according synced dirs in
          ${config.myHome.gaming.emulation.basePath}.
        '';
        default = {};
      };

      manifests = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            target = lib.mkOption {
              type = lib.types.str;
              description = "Target executable or file path.";
            };
            startIn = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Working directory for the application.";
            };
            launchOptions = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Additional launch options or arguments.";
            };
            appendArgsToExecutable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to append launchOptions to the executable path.";
            };
          };
        });
        description = "Steam ROM Manager manifests for opening the emulators itself";
        default = {};
      };
    };
  };

  config = {
    home.file = let
      basePath = config.myHome.gaming.emulation.basePath;

      # Create a symlink for each mapping in emulation.syncPaths
      syncPathSymlinks =
        lib.mapAttrs' (
          emuPath: syncPath:
            lib.nameValuePair "${config.home.homeDirectory}/${emuPath}" {
              source = config.lib.file.mkOutOfStoreSymlink "${basePath}/${syncPath}";
            }
        )
        config.myHome.gaming.emulation.syncPaths;

      # Create a manifest file for each mapping in emulation.manifests
      manifestFiles =
        lib.mapAttrs' (
          name: manifest:
            lib.nameValuePair "${basePath}/manifests/${name}.json" {
              text = builtins.toJSON {
                title = name;
                target = manifest.target;
                startIn = manifest.startIn;
                launchOptions = manifest.launchOptions;
                appendArgsToExecutable = manifest.appendArgsToExecutable;
              };
            }
        )
        config.myHome.gaming.emulation.manifests;

      # Ignore those manifest files in syncthing
      stignore = {
        "${basePath}/.stignore".text = ''
          manifests/
        '';
      };
    in
      syncPathSymlinks // manifestFiles // stignore;

    services.syncthing = {
      enable = true;
      settings = {
        options = {
          localAnnounceEnabled = false;
          urAccepted = -1;
        };
        devices = {
          "memoryhole" = {
            addresses = ["tcp://memoryhole:22000"];
            id = "7RWTI5N-O3IYKD3-HBVV257-W3CMNYZ-JGXBOQG-TVY5EQ3-AU2KLBP-QR2IHAQ";
          };
        };
        # Accept emulation folder from memoryhole
        folders."${config.myHome.gaming.emulation.basePath}" = {
          label = "Emulation";
          devices = ["memoryhole"];
          id = "a4cm6-wfkch"; # Defined by memoryhole
          # Intentionally leaving versioning to memoryhole
        };
      };
    };
  };
}
