{...}: {
  programs.eza = {
    enable = true;
    enableBashIntegration = true;

    icons = "auto";
    git = true;
    extraOptions = [
      "--header"
      "--group-directories-first"
    ];
  };

  programs.bat = {
    enable = true;

    # TODO: style
  };

  programs.ripgrep.enable = true;

  programs.bash.shellAliases = {
    cat = "bat";
    grep = "rg";
  };
}
