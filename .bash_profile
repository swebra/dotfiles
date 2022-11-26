# bashrc sourced by interactive, non-login shell (new terminal emulator window)
# bash_profile sourced by login shell (on login to desktop environment)
# Anything that can be inherited by sub shells should be placed in bash_profile to minimize terminal emulator startup time

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Use dotbare for dotfile management
export DOTBARE_DIR="$HOME/.dotfiles"
source ~/.dotbare/dotbare.plugin.bash

# Basic environment variables
export VISUAL=micro
export EDITOR="$VISUAL"
export BROWSER=vivaldi-stable
