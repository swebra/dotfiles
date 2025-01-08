{...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      line_break.disabled = true;
      character.error_symbol = "[✗](bold red)";

      aws.disabled = true;
      package.disabled = true;
      container.disabled = true;

      python = {
        format = "with [\${symbol}\${pyenv_prefix}(\${version} )]($style)";
        # Only show when virtual environment is enabled
        detect_extensions = [];
        detect_files = [];
      };

      nix_shell = {
        format = "via [\${symbol}( \\($state\\))]($style) ";
        symbol = "󱄅";
        impure_msg = "";
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
