# Dotfiles
Configuration files as a bare repository, managed (optionally) using [dotbare](https://github.com/kazhala/dotbare). Primarily written for a desktop Arch-based distro (Manjaro) but also designed to be used with a WSL 2 Ubuntu instance for work.

## Migrating to a new system
### Via dotbare
1. [Install dotbare](https://github.com/kazhala/dotbare#bash) and [required dependency](https://github.com/kazhala/dotbare#required-dependency) (fzf).
1. ```bash
   export DOTBARE_DIR="$HOME/.dotfiles" # Bare repo location
   dotbare finit -u git@github.com:swebra/dotfiles.git
   ```

### Natively
See the [Atlassian tutorial](https://www.atlassian.com/git/tutorials/dotfiles).

## Untracked files
Configuration overrides or security-sensitive files which are not committed but should still be considered and backed up:
- `.bashrc_extra` - Machine-specific `.bashrc` overrides/extension (work aliases)
- `.config/git/gitconfig_extra` - Machine-specific `.gitconfig` overrides/extension (work name/email)
- `.ssh/config` - SSH configuration
- `.aws/config` - AWS CLI configuration

## Referenced programs
- bash - shell
- git - source control
- [starship](https://starship.rs) - shell prompt
- [exa](https://the.exa.website) - `ls` replacement
- [bat](https://github.com/sharkdp/bat) - `cat` replacement
- [delta](https://github.com/dandavison/delta) - improved (git diff) pager
- [fzf](https://github.com/junegunn/fzf) - fuzzy finder
- [micro](https://micro-editor.github.io) - terminal text editor
- [direnv](https://direnv.net) - virtual environment management
- [VSCode](https://code.visualstudio.com) - GUI text editor / IDE
   - [One Dark Pro](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme) - theme
   - [Rewrap](https://marketplace.visualstudio.com/items?itemName=stkb.rewrap) - comment wrapping
   - [Render Line Endings](https://marketplace.visualstudio.com/items?itemName=medo64.render-crlf) - eol rendering
   - [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - spell checking

## Unreferenced (but still used) programs
- [jq](https://stedolan.github.io/jq/) - CLI JSON processor
- [git-open](https://github.com/paulirish/git-open) - open repo remote in browser

## Styling
- [Meslo LG S Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/S) - font, also available as an [AUR package](https://aur.archlinux.org/packages/ttf-meslo)

## Note on global git hooks
There are two ways to manage global git hooks:
1. (What is done here) Setting [`core.hooksPath`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corehooksPath) globally to point to your hooks. This overrides the default `$GIT_DIR/hooks` value however, so for any local hooks to execute, you have to [call them from your global hooks](https://stackoverflow.com/a/71939092).
1. Setting [`init.templateDir`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-inittemplateDir) globally to point to a template directory with your global hooks. Your hooks will then be automatically copied into the local `$GIT_DIR/hooks` (`.git/hooks`) directory of any newly created repos, and existing repos can be updated by rerunning `git init`. Rerunning `git init` will not overwrite any files however, so if you already had local hooks or if you ever update your global hook, you have to manually copy.

Unfortunately both methods can temporarily break or be temporarily broken by in-repo hook management tools such as [pre-commit](https://pre-commit.com) or [husky](https://www.npmjs.com/package/husky). For method 1:
- `pre-commit install` will ["cowardly refuse" to install hooks](https://github.com/pre-commit/pre-commit/issues/1198) if `core.hooksPath` is set anywhere (locally or globally, even if it's set to the default value of `.git/hooks`), and a proposed override for this behavior was [rejected](https://github.com/pre-commit/pre-commit/issues/1198#issuecomment-844208591). This has to be worked around by temporarily disabling the global hooks to perform the install:
   ```bash
   globalHooksPath=$(git config --global core.hooksPath)
   git config --unset --global core.hooksPath
   pre-commit install
   git config --global core.hooksPath $globalHooksPath
   ```
- Husky will locally set `core.hooksPath` to its directory of hooks, which points git away from your global hooks. This can be worked around by un-setting the local path and symlinking the husky hooks to the default hook location so the global hooks still call the local hooks:
   ```bash
   git config --unset core.hooksPath
   rm -r .git/hooks
   # Symlink the husky hooks to the default location
   # A full path must be used, hence $(pwd)
   ln -s $(pwd)/<path/to/husky/hooks/> .git/hooks
   ```
