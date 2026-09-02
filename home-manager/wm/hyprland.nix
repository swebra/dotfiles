{
  config,
  pkgs,
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
      -- https://discourse.nixos.org/t/hyprland-with-uwsm-no-secret-service-available-on-login-kwallet-is-installed-but-it-wont-start-and-autounlock/69263/4
      -- Also added kwallet to VSCode's autostart
      -- https://code.visualstudio.com/docs/configure/settings-sync#_troubleshooting-keychain-issues
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
}
