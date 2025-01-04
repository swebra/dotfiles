# Nix dotfiles
Flake-based NixOS/home-manager configuration.

## Secret management
Sensitive configuration is stored in a private repo and referenced here through a flake input called `private`.

## Note on global git hooks
There are two ways to manage global git hooks:
1. (What is done here) Setting [`core.hooksPath`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corehooksPath) globally to point to your hooks. This overrides the default `$GIT_DIR/hooks` value however, so for any local hooks to execute, you have to [call them from your global hooks](https://stackoverflow.com/a/71939092).
1. Setting [`init.templateDir`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-inittemplateDir) globally to point to a template directory with your global hooks. Your hooks will then be automatically copied into the local `$GIT_DIR/hooks` (`.git/hooks`) directory of any newly created repos, and existing repos can be updated by rerunning `git init`. Rerunning `git init` will not overwrite any files however, so if you already had local hooks or if you ever update your global hook, you have to manually copy.

Unfortunately both methods can temporarily broken by in-repo hook management tools such as [pre-commit](https://pre-commit.com) or [husky](https://www.npmjs.com/package/husky). For method 1:
- `pre-commit install` will ["cowardly refuse" to install hooks](https://github.com/pre-commit/pre-commit/issues/1198) if `core.hooksPath` is set anywhere (locally or globally, even if it's set to the default value of `.git/hooks`), and a proposed override for this behavior was [rejected](https://github.com/pre-commit/pre-commit/issues/1198#issuecomment-844208591). This can be worked around by using the `init-templatedir` command to generate hooks without setting `core.hooksPath`,  warnings about `init.templateDir` not being set can be ignored:
   ```bash
   pre-commit init-templatedir --no-allow-missing-config .git
   ```
- Husky will locally set `core.hooksPath` to its directory of hooks, which points git away from your global hooks. This can be worked around by un-setting the local path and symlinking the husky hooks to the default hook location so the global hooks still call the local hooks:
   ```bash
   git config --unset core.hooksPath
   rm -r .git/hooks
   # Symlink the husky hooks to the default location
   # A full path must be used, hence $(pwd)
   ln -s $(pwd)/<path/to/husky/hooks/> .git/hooks
   ```
- Other tools like [git-hooks.nix](https://github.com/cachix/git-hooks.nix) simply populate `.git/hooks` and set `core.hooksPath` locally. This can be worked around by just unsetting the local config:
   ```bash
   git config --unset core.hooksPath
   ```
