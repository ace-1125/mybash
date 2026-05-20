# Tokyo Night prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

GRAY='\[\e[38;5;245m\]'
BLUE='\[\e[38;2;122;162;247m\]'
GREEN='\[\e[38;2;158;206;106m\]'
YELLOW='\[\e[38;2;224;175;104m\]'
RESET='\[\e[0m\]'

env_prefix() {
  local items=()

  [ -n "${VIRTUAL_ENV:-}" ] && items+=("$(basename "$VIRTUAL_ENV")")
  [ -n "${CONDA_DEFAULT_ENV:-}" ] && items+=("conda:${CONDA_DEFAULT_ENV}")
  [ -n "${NODE_ENV:-}" ] && items+=("node:${NODE_ENV}")
  [ -n "${AWS_PROFILE:-}" ] && items+=("aws:${AWS_PROFILE}")
  [ -n "${KUBECONFIG:-}" ] && items+=("kube")

  [ ${#items[@]} -gt 0 ] && printf "(%s)" "$(IFS=' | '; echo "${items[*]}")"
}

git_prompt() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch status ahead behind staged dirty untracked conflict flags=()
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
  status=$(git status --porcelain=v1 --branch 2>/dev/null) || return

  if [[ "$status" =~ \[ahead[[:space:]]([0-9]+) ]]; then
    ahead=${BASH_REMATCH[1]}
  fi

  if [[ "$status" =~ behind[[:space:]]([0-9]+) ]]; then
    behind=${BASH_REMATCH[1]}
  fi

  if printf '%s\n' "$status" | grep -qE '^(UU|AA|DD|AU|UD|UA|DU)'; then
    conflict=1
  fi

  if printf '%s\n' "$status" | grep -qE '^[MARCD]'; then
    staged=1
  fi

  if printf '%s\n' "$status" | grep -qE '^.[MARCD]'; then
    dirty=1
  fi

  if printf '%s\n' "$status" | grep -qE '^\?\?'; then
    untracked=1
  fi

  [ -n "$staged" ] && flags+=("+")
  [ -n "$dirty" ] && flags+=("*")
  [ -n "$untracked" ] && flags+=("?")
  [ -n "$conflict" ] && flags+=("!")
  [ -n "$ahead" ] && flags+=("⇡$ahead")
  [ -n "$behind" ] && flags+=("⇣$behind")

  printf "%s" "$branch"
  if [ ${#flags[@]} -gt 0 ]; then
    printf " %s" "$(IFS=''; echo "${flags[*]}")"
  fi
}

set_prompt() {
  sync_history

  local p g
  p=$(env_prefix)
  g=$(git_prompt)

  PS1=''

  if [ -n "$p" ]; then
    PS1+="${YELLOW}${p} ${RESET}"
  fi

  PS1+="${GRAY}\w${RESET}"$'\n'

  if [ -n "$g" ]; then
    PS1+="${GREEN}git(${BLUE}${g}${GREEN}) ${RESET}"
  fi

  PS1+="${BLUE}› ${RESET}"
}

PROMPT_COMMAND=set_prompt
