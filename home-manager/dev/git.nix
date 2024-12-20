{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "swebra";
    userEmail = "eric@swebra.com";

    aliases = {
      st = "status";
      l = "log --oneline --decorate --date=short --graph";
      d = "diff";
      ds = "diff --staged";
      a = "add";
      cm = "commit";
      cmm = "commit -m";
      co = "checkout";
      cob = "checkout -b";
      p = "push";
      pu = "push -u origin HEAD";
      pf = "push --force-with-lease";
    };

    ignores = [
      ".eric"
      "flake.nix"
      "flake.lock"
      # Python
      ".venv"
    ];

    delta = {
      enable = true;
      options = {
        nativate = true;
        map-styles = "bold purple => syntax purple, bold cyan => syntax cyan";
      };
    };
  };

  home.packages = [
    pkgs.git-open
  ];

  # TODO: More git config
}
