{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: let
  # Get all non-directories in hypr-config
  extra_hypr_files = builtins.attrNames (
    lib.attrsets.filterAttrs (_: file_type: file_type != "directory") (builtins.readDir ./hypr-config)
  );
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Installed at OS-level
    portalPackage = null; # Installed at OS-level
    systemd.enable = false; # Using USWM at OS-level

    configType = "lua";
    extraConfig = ''
      -- Unlock KWallet from PAM (display manager like SDDM) login
      -- Normally this init is run in a service triggered by other KDE services
      -- https://wiki.archlinux.org/title/KDE_Wallet#Unlocking_KWallet_automatically_in_a_window_manager
      -- https://discourse.nixos.org/t/hyprland-with-uwsm-no-secret-service-available-on-login-kwallet-is-installed-but-it-wont-start-and-autounlock/69263/4
      -- Keyring availability can be tested with secret-store as shown in thread above
      hl.on("hyprland.start", function()
        hl.exec_cmd("${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init")
      end)

      ${
        lib.concatMapStringsSep "\n"
        (file: "require(\"${lib.removeSuffix ".lua" file}\")")
        extra_hypr_files
      }
    '';
  };

  # Out-of-store symlink all files in hypr-config to ~/.config/hypr
  xdg.configFile = let
    parentDir = "${config.myHome.dotfilesDir}/home-manager/wm/hypr-config";
  in
    builtins.listToAttrs (builtins.map (lua_file: {
        name = "hypr/${lua_file}";
        value.source = config.lib.file.mkOutOfStoreSymlink "${parentDir}/${lua_file}";
      })
      extra_hypr_files);

  # VSCode doesn't recognize the DE, so doesn't autodetect which keyring to use
  # https://code.visualstudio.com/docs/configure/settings-sync#_linux
  # https://github.com/microsoft/vscode/issues/187338
  # Configure it Use a Secret Service provider (such as KWallet)
  programs.vscode.package = lib.mkForce (pkgs-unstable.vscode.override {
    commandLineArgs = ["--password-store=gnome-libsecret"];
  });
}
