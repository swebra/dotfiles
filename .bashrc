# Exit if not running interactively
[[ $- != *i* ]] && return

# Bash fixes
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend
HISTCONTROL=ignoreboth

# Let root use X11
xhost +local:root > /dev/null 2>&1

# Source bash completions
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion


# Helper Functions
# ================
# ex <file>
# Extracts archives
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


# General Aliases
# ===============
alias ls='exa'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias m="micro"


# Shell Setup
# ===========
# Use starship prompt
eval "$(starship init bash)"
# Use fzf keybindings
distro_id=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
if [[ $distro_id != 'ubuntu' ]]; then
    source /usr/share/fzf/key-bindings.bash
else
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
unset distro_id
# Use direnv
eval "$(direnv hook bash)"

# Dev Setup
# =========
# Python
export PIP_REQUIRE_VIRTUALENV=1
gpip() {
    PIP_REQUIRE_VIRTUALENV=0 python -m pip "$@"
}
mkpyvenv() {
    echo 'layout python' > .envrc
    direnv allow
    direnv exec . pip install wheel flake8
}
