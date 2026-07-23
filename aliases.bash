# Colors + common aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias nr='npm run'
alias cp='cp -i'
alias mv='mv -i'
alias py='python3'
alias pysrc='source .venv/bin/activate'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Move removed files into /tmp so accidental deletes are recoverable until reboot.
rm() {
  local trash_root="${TMPDIR:-/tmp}/trash-$USER"
  local stamp
  local verbose=
  local force=
  local status=0
  local targets=()

  stamp=$(date +%Y%m%d-%H%M%S)
  mkdir -p "$trash_root" || return

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --)
        shift
        targets+=("$@")
        break
        ;;
      -*)
        case "$1" in
          *v*) verbose=1 ;;
        esac
        case "$1" in
          *f*) force=1 ;;
        esac
        ;;
      *)
        targets+=("$1")
        ;;
    esac
    shift
  done

  if [ "${#targets[@]}" -eq 0 ]; then
    command rm
    return
  fi

  for target in "${targets[@]}"; do
    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
      [ -z "$force" ] && printf "rm: cannot remove '%s': No such file or directory\n" "$target" >&2
      status=1
      continue
    fi

    local base dest n
    base=$(basename -- "$target")
    dest="$trash_root/$stamp-$base"
    n=1

    while [ -e "$dest" ] || [ -L "$dest" ]; do
      dest="$trash_root/$stamp-$n-$base"
      n=$((n + 1))
    done

    if mv -- "$target" "$dest"; then
      [ -n "$verbose" ] && printf "trashed '%s' -> '%s'\n" "$target" "$dest"
    else
      status=1
    fi
  done

  return "$status"
}

# List after successful directory changes. Compact for small dirs, denser for large ones.
cd() {
  builtin cd "$@" || return

  local count
  count=$(find . -mindepth 1 -maxdepth 1 2>/dev/null | head -n 31 | wc -l)

  if [ "$count" -gt 30 ]; then
    ls -Ag
  else
    ls -A
  fi
}

mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
