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

      alias = let
        aligned-tag-name = "%(align:8)%(refname:short)%(end)";
        # Annotated tags have objecttype "tag", while lightweight tags have "commit"
        colored-tag-name = "%(if:equals=tag)%(objecttype)%(then)%(color:yellow)%(else)%(color:blue)%(end)${aligned-tag-name}%(color:reset)";
        tag-date = "%(color:cyan)(%(creatordate:relative))%(color:reset)";
        tag-subject = "%(if)%(subject)%(then)%(subject)%(else)%(color:red)-%(color:reset)%(end)";
        tag-format = "${colored-tag-name} ${tag-subject} ${tag-date}";
      in {
        # Current state
        st = "status";
        l = "log --oneline --decorate --date=short --graph";
        rl = "log -10";
        tags = "for-each-ref --sort='-version:refname' --format='${tag-format}' refs/tags";
        rtags = "tags --count=5"; # Use for-each-ref above instead of tag because it has a --count arg

        # Development
        d = "diff";
        ds = "diff --staged";
        a = "add";
        cm = "commit";
        cmm = "commit -m";
        co = "checkout";
        cob = "checkout -b";

        # Pushing
        p = "push";
        pu = "push -u origin HEAD";
        pf = "push --force-with-lease";
      };

      diff.colorMoved = "default";
      merge.conflictStyle = "zdiff3";
      tag.sort = "-version:refname"; # Parse tags as (semantic) versions
      push.followTags = true; # Push annotated tags when pushing commits
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

  programs.bash.shellAliases.g = "git";
}
