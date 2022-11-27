# Dotfiles
Configration files as a bare repository, managed (optionally) using [dotbare](https://github.com/kazhala/dotbare).

## Migrating to a new system
### Via dotbare
1. [Install dotbare](https://github.com/kazhala/dotbare#bash) and [required dependency](https://github.com/kazhala/dotbare#required-dependency) (fzf).
1. ```bash
   export DOTBARE_DIR="$HOME/.dotfiles" # Bare repo location
   dotbare finit -u git@github.com:swebra/dotfiles.git
   ```

### Natively
See the [Atlassian tutorial](https://www.atlassian.com/git/tutorials/dotfiles).


## Used Programs
- bash - shell
- git - source control
- [starship](https://starship.rs) - shell prompt
- [exa](https://the.exa.website) - `ls` replacement
- [fzf](https://github.com/junegunn/fzf) - fuzzy finder
- [micro](https://micro-editor.github.io) - terminal text editor
- [direnv](https://direnv.net) - virtual environment management
