{pkgs, ...}: {
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
    extraPackages = [pkgs.bat-extras.batgrep];

    config = {
      theme = "onedark";
    };

    themes = {
      # TODO: More accurate theme?
      onedark = {
        src = pkgs.fetchFromGitHub {
          owner = "kristoferfannar";
          repo = "onedark-bat";
          rev = "6a3e95ffa8938956bbadb94dd5d36cfe4c1b94b8";
          sha256 = "sha256-BYrQ0tLnBcODohVXkxlx4Xy/Kaf6WizcdQFTfmCLFHU=";
        };
        file = "onedark.tmTheme";
      };
    };
  };

  programs.bash.shellAliases = {
    cat = "bat";
    grep = "batgrep";
  };
}
