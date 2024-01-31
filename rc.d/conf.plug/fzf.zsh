#!/usr/bin/env zsh

# If we currently don't have fzf avaialble then we isntall it and link it to
# our local bin.
if ((! $+commands[fzf])); then
  ~[junegunn/fzf]/install --no-fish --no-bash --bin
  ln -sf ~[junegunn/fzf]/bin/fzf $XDG_BIN_HOME/fzf
fi


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
  job=$(jobs | fzf | rg '[0-9]' -o)
  BUFFER="fg %${job}"

  zle accept-line
  zle reset-prompt
}

fzf-change-to-dev-project() {
  local cmd="fdfind -t d -HI -g '**/.git' $XDG_DEV_HOME --exec dirname {}"
  local dir=$(eval $cmd | FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS} fzf)
  if [ -z ${dir} ]; then
    zle reset-prompt
    return
  fi

  BUFFER="builtin cd -- ${(q)dir}"
  zle accept-line
  zle reset-prompt
}

# Expose zle functions
zle -N fzf-echo-env
zle -N fzf-select-job
zle -N fzf-insert-history
zle -N fzf-change-directory
zle -N fzf-change-to-dev-project

# fzf keybinds
bindkey -M vicmd '^@p' fzf-echo-env
bindkey -M vicmd '^@j' fzf-select-job
bindkey -M vicmd '^@t' fzf-change-directory
bindkey -M vicmd '^@\\' fzf-change-to-dev-project

# Add completion & base functions from fzf/shell directory
source ~[junegunn/fzf]/shell/key-bindings.zsh
znap fpath _fzf '< ~[junegunn/fzf]/shell/completion.zsh'

FZF_DEFAULT_OPTS="--height -40% --reverse --scheme=path --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_T_OPTS-}"

if (($+commands[fdfind])); then
  export FZF_CTRL_T_COMMAND="fdfind . --hidden"
  export FZF_ALT_C_COMMAND="fdfind -HI --type directory"
fi