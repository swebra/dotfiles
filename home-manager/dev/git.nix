{
  pkgs,
  lib,
  ...
}: {
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
      ".eric" # Notes
      ".venv" # Python
    ];

    extraConfig = {
      diff.colorMoved = "default";
      merge.conflictStyle = "diff3";

      # TODO: move these VSCode settings into VSCode-specific program config
      diff.tool = "vscode";
      difftool = {
        prompt = false;
        vscode.cmd = "code --wait --diff $LOCAL $REMOTE";
      };

      merge.tool = "vscode";
      mergetool = {
        keepBackup = "false";
        vscode.cmd = "code --wait $MERGED";
      };
    };

    delta = {
      enable = true;
      options = {
        nativate = true;
        map-styles = "bold purple => syntax purple, bold cyan => syntax cyan";
      };
    };

    hooks = let
      runLocalHookLib = pkgs.python3Packages.buildPythonPackage {
        pname = "run-local-git-hook";
        version = "1.0.0";

        src = ./gitHooks;
        format = "pyproject";
        nativeBuildInputs = [pkgs.python3Packages.hatchling];
      };

      # TODO: Could use toPythonApplication? Maybe need scripts defined in pyproject.toml
      runLocalHook = lib.getExe (
        pkgs.writers.writePython3Bin "runLocalHook" {} ./gitHooks/run_local_hook.py
      );

      prepareCommitMsg = lib.getExe (
        pkgs.writers.writePython3Bin "prepareCommitMsg" {
          libraries = [runLocalHookLib];
          flakeIgnore = ["E501"];
        }
        ./gitHooks/prepare_commit_msg.py
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

  home.packages = [
    pkgs.git-open
  ];
}
