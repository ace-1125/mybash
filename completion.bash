bind 'set completion-ignore-case on'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# fzf integration, if installed.
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  . /usr/share/doc/fzf/examples/key-bindings.bash
elif [ -f /usr/share/fzf/key-bindings.bash ]; then
  . /usr/share/fzf/key-bindings.bash
elif [ -f ~/.fzf.bash ]; then
  . ~/.fzf.bash
fi

if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
  . /usr/share/doc/fzf/examples/completion.bash
elif [ -f /usr/share/fzf/completion.bash ]; then
  . /usr/share/fzf/completion.bash
fi
