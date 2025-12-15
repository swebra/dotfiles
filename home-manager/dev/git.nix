{
  lib,
  pkgs,
  private,
  ...
}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "swebra";
        email = private.personal.email;
      };

      alias = {
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

      diff.colorMoved = "default";
      merge.conflictStyle = "zdiff3";
      push.followTags = true;
    };

    ignores = [
      ".eric" # Notes
      ".venv" # Python
    ];

    hooks = let
      runLocalHookLib = pkgs.python3Packages.buildPythonPackage {
        pname = "run-local-git-hook";
        version = "1.0.0";

        src = ./git-hooks;
        format = "pyproject";
        nativeBuildInputs = [pkgs.python3Packages.hatchling];
      };

      # TODO: Could use toPythonApplication? Maybe need scripts defined in pyproject.toml
      runLocalHook = lib.getExe (
        pkgs.writers.writePython3Bin "runLocalHook" {} ./git-hooks/run_local_hook.py
      );

      prepareCommitMsg = lib.getExe (
        pkgs.writers.writePython3Bin "prepareCommitMsg" {
          libraries = [runLocalHookLib];
          flakeIgnore = ["E501"];
        }
        ./git-hooks/prepare_commit_msg.py
      );
    in {
      commit-msg = runLocalHook;
      pre-commit = runLocalHook;
      pre-merge-commit = runLocalHook;
      pre-push = runLocalHook;
      pre-rebase = runLocalHook;
      prepare-commit-msg = prepareCommitMsg;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      map-styles = "bold purple => syntax purple, bold cyan => syntax cyan";
    };
  };

  home.packages = [
    pkgs.git-open
  ];
}
