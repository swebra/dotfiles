# Nix dotfiles
Flake-based NixOS/home-manager configuration.

## Bootstrap dotfiles on a new system
Assuming nix is installed and flakes are enabled, apply the `default` configuration with the following:
```bash
nix run home-manager -- switch -b backup --flake github:swebra/dotfiles#default

# or
git clone git@github.com:swebra/dotfiles.git ~/.dotfiles
nix run home-manager -- switch -b backup --flake ~/.dotfiles#default
```
Note the user is expected to match `home.username` in [hosts/default/home.nix](./hosts/default/home.nix), which is `eric` by default.

If selecting a different configuration that references private values (see below), access to the private repo through SSH will also be required.

## Notes on nix structure
### Secret management
Sensitive configuration is stored in a private repo and referenced here through a flake input called `private`.

### Imports
The top-level `default.nix` files in the `home-manager/` and `nixos/` dirs programmatically import all sibling/child files and generates their enable options using `recursiveOptionedImport`. See the function's definition in [`myLib/`](./myLib/default.nix) for more details, but also note that traditional, explicit imports of these files (`imports = [ ./path/to/file ]`) would still work.

## Notes on configuration
### Global git hooks
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
