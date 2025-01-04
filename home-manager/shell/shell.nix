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

  # Prompt + CLI interaction
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      line_break.disabled = true;
      character.error_symbol = "[✗](bold red)";

      aws.disabled = true;
      package.disabled = true;
      container.disabled = true;

      nix_shell = {
        # symbol = "❄️";
        symbol = "";
        impure_msg = "";
        pure_msg = "";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      cat = "bat";
      grep = "rg";
      dc = "docker compose";
    };

    # Ignore duplicate commands and space-prefix commands in history
    historyControl = ["ignoreboth"];
  };

  home.file.".inputrc".text = ''
    set completion-ignore-case On

    # Control + backspace
    "\C-h": backward-kill-word
  '';
}
