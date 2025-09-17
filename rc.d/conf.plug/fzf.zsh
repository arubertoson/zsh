#!/usr/bin/env zsh

# If we currently don't have fzf avaialble then we isntall it and link it to
# our local bin.
if ((! $+commands[fzf])); then
  ~[junegunn/fzf]/install --no-fish --no-bash --bin
  ln -sf ~[junegunn/fzf]/bin/fzf $XDG_BIN_HOME/fzf
fi

FDFIND_COMMAND=fd

fzf-echo-env() {
  local env=$(env | cut -f1 -d"=" | FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS} fzf)

  if [ -z ${env} ]; then
    zle reset-prompt
    return
  fi

  echo $(printenv $env) | tr ":" "\n"
  zle reset-prompt
}

fzf-select-job() {
  job=$(jobs | FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS} fzf | rg '[0-9]' -o)
  BUFFER="fg %${job}"

  zle accept-line
  zle reset-prompt
}

# fzf_change_to_dev_project — lean project switcher for XDG_DEV_HOME / ~/dev
# Puts a safe `cd <dir>` into the interactive buffer and executes it (no subshell).
# Requires: fd (or fdfind) and fzf.
fzf-change-to-dev-project() {
  local DEV_ROOT="${XDG_DEV_HOME:-$HOME/dev}"
  local FD_CMD

  # we force insert mode as we are driving a cd change and most likely want to
  # do stuff directly. NOTE--this is done through the zvm plugin.
  zvm_select_vi_mode $ZVM_MODE_INSERT

  FD_CMD="$(command -v fdfind 2>/dev/null || command -v fd 2>/dev/null || true)"
  SD_CMD="$(command -v sd 2>/dev/null || true)"

  # Find repository roots by locating .git directories, then strip the trailing /.git
  # -H: include hidden; -I: don't respect .gitignore (we want to find .git)
  # --base-directory to return only the base directories (project dirs).
  local list
  list="$("$FD_CMD" -L -HI -t d '^\.git$' --base-directory "$DEV_ROOT" 2>/dev/null | $SD_CMD '/\.git/$' '')"
  if [ -z "$list" ]; then
    zle reset-prompt
    return 0
  fi

  # Use fzf to pick; --select-1 auto-accepts single result, --exit-0 returns 0 on no match
  # Keep FZF_DEFAULT_OPTS if user defined it.
  local fzf_opts="${FZF_DEFAULT_OPTS:-}"
  local dir
  dir="$(printf '%s\n' "$list" | FZF_DEFAULT_OPTS="$fzf_opts" \
        fzf --ansi --no-hscroll --height=40% --layout=reverse --exit-0)"

  # Cancelled or no selection — restore prompt
  if [ -z "$dir" ]; then
    zle reset-prompt
    return 0
  fi

  # Safe quoting and execute in current shell
  BUFFER="builtin cd -- $DEV_ROOT/${(q)dir}"
  zle silent-accept-line
  # zle quiet-accept-line

  printf '\r\033[38;5;12m%s\033[0m' "~dev/$dir"
  zle accept-line
}

# Expose zle functions
zle -N fzf-echo-env
zle -N fzf-select-job
zle -N fzf-change-to-dev-project

# fzf keybinds
bindkey -M vicmd '^@p' fzf-echo-env
bindkey -M vicmd '^@j' fzf-select-job
bindkey -M vicmd '^@\\' fzf-change-to-dev-project

# Add completion & base functions from fzf/shell directory
source ~[junegunn/fzf]/shell/key-bindings.zsh
znap fpath _fzf '< ~[junegunn/fzf]/shell/completion.zsh'

if (($+commands[fd])); then
  export FZF_CTRL_T_COMMAND="$FDFIND_COMMAND . --hidden"
  export FZF_ALT_C_COMMAND="$FDFIND_COMMAND -HI --type directory"
fi
