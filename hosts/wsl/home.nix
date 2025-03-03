{
  pkgs,
  config,
  private,
  lib,
  ...
}: {
  myHome = {
    dev.enable = true;
    work-dev.enable = true;
    windows.enable = true;
  };

  programs.git = {
    userName = lib.mkForce "Eric Claerhout";
    userEmail = lib.mkForce private.work.email;
  };

  home.sessionVariables = {
    # Wrap as shell script to work around spaces in path for tools like git-open
    BROWSER = lib.getExe (pkgs.writeShellScriptBin "zen-browser" ''
      /mnt/c/Program\ Files/Zen\ Browser/zen.exe "$@"
    '');
  };

  # Home-manager config
  home.username = "eric";
  home.homeDirectory = "/home/${config.home.username}";

  # Do not update for new release cycle, see home manager docs
  home.stateVersion = "24.05"; # Did you read the comment?
}
