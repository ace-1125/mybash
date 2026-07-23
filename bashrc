# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

BASH_SOURCE_PATH="${BASH_SOURCE[0]}"

if command -v readlink >/dev/null 2>&1; then
  BASH_SOURCE_PATH="$(readlink -f "$BASH_SOURCE_PATH")"
fi

BASH_CONFIG_DIR="$(builtin cd -- "$(dirname "$BASH_SOURCE_PATH")" && pwd)"

# History
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT='%F %T '

shopt -s histappend
shopt -s cdspell
shopt -s dirspell
shopt -s autocd
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
export PATH="$HOME/.local/bin:$PATH"
