{config, ...}: {
  programs.micro = {
    enable = true;

    settings = {
      remtrailingws = true;
      softwrap = true;
      tabmovement = true;
      tabstospaces = true;
      clipboard = "terminal"; # Requires OSC52 support in terminal
    };
  };

  # Waiting for https://github.com/nix-community/home-manager/pull/3224

  home.file."${config.xdg.configHome}/micro/bindings.json".text = builtins.toJSON {
    CtrlUp = "MoveLinesUp";
    CtrlDown = "MoveLinesDown";
    CtrlUnderscore = "lua:comment.comment";
    "Alt-/" = "lua:comment.comment";
  };

  # TODO: Make setting the default an option instead
  programs.bash.shellAliases.m = "micro";
  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
}
