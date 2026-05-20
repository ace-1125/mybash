# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

BASH_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# History
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT='%F %T '

shopt -s histappend
shopt -s cdspell
shopt -s checkwinsize

sync_history() {
  history -a
  history -n
}

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

. "$BASH_CONFIG_DIR/aliases.bash"
. "$BASH_CONFIG_DIR/completion.bash"
. "$BASH_CONFIG_DIR/prompt.bash"

# Local tools
export PATH="$HOME/localNode/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

[ -f ~/.bashrc.local ] && . ~/.bashrc.local
