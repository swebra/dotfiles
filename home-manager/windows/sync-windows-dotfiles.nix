{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    myHome.windows.syncPaths = lib.mkOption {
      type = with lib.types; listOf (listOf (oneOf [str path]));
      default = [];
      description = ''
        Paths to sync to Windows. Takes the form of a list of lists, where the first element is the
        source path (from Linux) and the second element is the destination path relative to
        $USERPROFILE.

        Note that rsync syntax is used, so a trailing slash on a source directory will copy the
        contents of the directory instead of the directory itself.

        Note also that files are never deleted Windows-side, regardless of configuration changes.
      '';
      example = lib.options.literalExpression ''
        [
          ["/path/to/source" "/path/to/destination"]
        ]
      '';
    };
  };

  config = {
    # Activation script to verify USERPROFILE on home switch
    # This activation is not explicitly required, but the error message is useful
    home.activation.checkWindowsUserProfileExists = lib.hm.dag.entryBefore ["writeBoundary"] ''
      # Explicit variable set check (-v) because of `set -eu` environment
      if [[ ! -v USERPROFILE || ! -d "$USERPROFILE" ]]; then
        errorEcho 'Windows USERPROFILE environment variable not set, empty, or is not an existing directory.'
        errorEcho "Value is: $USERPROFILE"
        errorEcho 'USERPROFILE can be set through the Windows WSLENV environment variable, see'
        errorEcho 'https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/'
        exit 1
      fi
    '';

    # Activation script to copy files to Windows on home switch
    # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
    home.activation.syncWindowsDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] (let
      /*
      Given a (linux) source and a destination, format an rsync command to copy the source to the destination.

      Notes:
        Wrapped with `run` and uses $VERBOSE_ARG as per home-manager docs
        -a to copy (almost) all properties, overridden by following options
        --mkpath to create parent directories
        --copy-links to handle symlinks
        --chmod to set permissions (all for folders, read only for files)
        --checksum to compare files by checksum, avoiding sync-skips due to WSL time drift
        Note the lack of --delete
      */
      formatCmd = src: dest: ''
        verboseEcho ""
        verboseEcho "Syncing ${src} to $USERPROFILE/${dest}"
        run ${pkgs.rsync}/bin/rsync $VERBOSE_ARG \
          -a --mkpath --copy-links --chmod=Da=rwx,Fa=r --checksum \
          ${src} "$USERPROFILE/${dest}"
      '';
    in ''
      verboseEcho "Syncing windows dotfiles to $USERPROFILE"
      ${lib.strings.concatMapStrings
        (pathPair: formatCmd (builtins.elemAt pathPair 0) (builtins.elemAt pathPair 1))
        config.myHome.windows.syncPaths}
    '');
  };
}
