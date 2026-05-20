# mybash

Small, boring Bash config with a clean prompt and a few safety rails.

This repo is intentionally not a shell framework. The goal is to keep Bash predictable while making the daily terminal feel authored, recoverable, and pleasant to use.

## Principles

- **Bash stays boring.** No plugin manager, no heavy prompt engine, no hidden framework behavior.
- **The prompt matters.** The prompt is two-line, TokyoNight-inspired, and shows only useful context: current path, active envs, and compact git state.
- **Safety beats cleverness.** `rm` moves files into `/tmp/trash-$USER` so accidental deletes are recoverable until reboot.
- **Navigation should have feedback.** Successful `cd` automatically lists the destination, compactly for small directories and more densely for large ones.
- **Completion should help without taking over.** Bash completion is enabled, completion is case-insensitive, and fzf is sourced only if installed.
- **Local differences stay local.** `~/.bashrc.local` is sourced if present and should stay out of git.

## Files

```text
.
├── bashrc           # entrypoint; history/options/local tools
├── aliases.bash     # aliases, safe rm, cd wrapper
├── completion.bash  # bash-completion and optional fzf integration
├── prompt.bash      # TokyoNight prompt + git/env context
└── bootstrap.sh     # symlink helper for ~/.bashrc
```

## Prompt

The prompt keeps the terminal calm, and git status only shows when inside a repo:

```text
/path/to/project
git(mainline +*?⇡1) ›
```

Git flags are compact:

- `+` staged changes
- `*` unstaged tracked changes
- `?` untracked files
- `!` conflicts
- `⇡N` ahead of upstream
- `⇣N` behind upstream

Environment context appears before the path when present, for example:

```text
(venv | aws:personal) ~/project
git(mainline *) ›
```

## Install

From this repo:

```bash
chmod +x bootstrap.sh
mv ~/.bashrc ~/.bashrc.bak
./bootstrap.sh
source ~/.bashrc
```

`bootstrap.sh` will update an existing `~/.bashrc` symlink, but it will not overwrite a real file.

## Local overrides

Put machine-specific or private config in:

```text
~/.bashrc.local
```

Examples:

```bash
export WORKON_HOME="$HOME/.virtualenvs"
alias workvpn="..."
```

Do not commit secrets, employer-specific internals, or machine-only paths unless they are safe to publish.
