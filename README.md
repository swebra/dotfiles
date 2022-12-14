# Dotfiles
Configuration files as a bare repository, managed (optionally) using [dotbare](https://github.com/kazhala/dotbare). Primarily written for a desktop, Arch-based distro (Manjaro) but also designed to be used with a WSL 2 Ubuntu instance for work.

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
- `.gitconfig_extra` - Machine-specific `.gitconfig` overrides/extension (work name/email)
- `.ssh/config` - SSH configuration
- `.aws/config` - AWS CLI configuration

## Referenced programs
- bash - shell
- git - source control
- [starship](https://starship.rs) - shell prompt
- [exa](https://the.exa.website) - `ls` replacement
- [bat](https://github.com/sharkdp/bat) - `bat` replacement
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
