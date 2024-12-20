{config, ...}: {
  programs.micro = {
    enable = true;

    settings = {
      remtrailingws = true;
      softwrap = true;
      tabmovement = true;
      tabstospaces = true;
    };
  };

  # Waiting for https://github.com/nix-community/home-manager/pull/3224

  home.file."${config.xdg.configHome}/micro/bindings.json".text = builtins.toJSON {
    CtrlUp = "MoveLinesUp";
    CtrlDown = "MoveLinesDown";
  };

  # TODO: Make settings the default an option instead
  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
}
