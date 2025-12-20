{
  config,
  lib,
  ...
}: {
  options = {
    myHome.gaming.emulation = {
      basePath = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/Games/Emulation";
        description = "Base path for emulation-related files.";
      };

      syncPaths = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = ''
          Attribute set mapping of emulator paths to according synced dirs in
          ${config.myHome.gaming.emulation.basePath}.
        '';
        default = {};
      };
    };
  };

  config = {
    # Create a symlinks for each mapping in emulation.syncPaths
    home.file = let
      basePath = config.myHome.gaming.emulation.basePath;
    in
      lib.mapAttrs' (
        emuPath: syncPath:
          lib.nameValuePair "${config.home.homeDirectory}/${emuPath}" {
            source = config.lib.file.mkOutOfStoreSymlink "${basePath}/${syncPath}";
          }
      )
      config.myHome.gaming.emulation.syncPaths;

    # TODO:
    # - Add manifest support
    # - Check if they (symlinks) are synced by syncthing, if not end here
    # - Check if .stignore file is synced, if so create one to ignore manifests and end here
    # - Otherwise declaratively create .stignore in nix

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
            id = "GU7AVMS-OZZSGMB-6JR4IRR-FNJU3X7-E2AC7JC-PHSO3JY-XMVOUM3-ZELGKAS";
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
