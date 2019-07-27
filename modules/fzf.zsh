#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# FZF
# ----------------------------------------------------------------------------

# Only Continue if fzf is available
if (! command -v fzf &> /dev/null); then
  echo "fzf is not available - install if you want to activate fzf widgets"
  return
fi


# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

FZF_DEFAULT_OPTS='--height 40% --layout=reverse'

if (command -v rg &> /dev/null); then
  export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

if (command -v fd &> /dev/null); then
  export FZF_ALT_C_COMMAND="fd -HI --type directory"
fi

# Source stuff
fzf_base=$(dirname $(realpath $(which fzf)))/..
source "${fzf_base}/shell/completion.zsh"
source "${fzf_base}/shell/key-bindings.zsh"


# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

fzf-icat() {
  image=$( \
    rg -f * --maxdepth 1 | \
    map file --mime-type | \
    rg image | fzf | cut -f1 -d":" \
  )

  kitty icat ${image}
}


fzf-echo-env() { 
  echo ''
  env | cut -f1 -d"=" | fzf | xargs printenv | tr ":" "\n"
  echo ''
  zle reset-prompt
}


fzf-change-directory() {
  builtin cd $(find -type d -printf '%P\n' | fzf --tac)
}


fzf-select-job() {
  job=$(jobs | fzf | rg '[0-9]' -o)
  BUFFER="fg %${job}"

  zle accept-line
  zle reset-prompt
}


fzf-insert-history() {
  hist=$(fc -l 1 \
    | fzf --tac --tiebreak=index --query="$LBUFFER" +m \
    | sed 's/^ *[0-9]* *//'
  )


  if [ -n ${hist} ];then
    BUFFER=${hist}
    zle accept-line
    zle reset-prompt
  fi
}


fzf-change-to-ghq-project() {
  proj=$(ghq list \
    | sort \
    | fzf
  )

  if [ -n ${proj} ];then
    BUFFER="cd ${GHQ_ROOT}/${proj}"
    zle accept-line
    zle reset-prompt
  fi
}

# Expose zle functions
zle -N fzf-icat
zle -N fzf-echo-env
zle -N fzf-select-job
zle -N fzf-insert-history
zle -N fzf-change-directory
zle -N fzf-change-to-ghq-project

# ----------------------------------------------------------------------------
# Key Maps
# ----------------------------------------------------------------------------

# Custom Functions bindings
bindkey "^@\\" fzf-change-to-ghq-project
bindkey "^@i" fzf-icat
bindkey "^@j" fzf-select-job
bindkey "^@p" fzf-echo-env
bindkey "^@t" fzf-change-directory
bindkey '^@h' fzf-insert-history


# Fzf-widget plugin
if [ -n "$(declare -fF fzf-select-widget)" ]; then
  bindkey '^@r' fzf-select-widget
  bindkey '^@f' fzf-edit-files

  bindkey '^@ga' fzf-git-add-files
  bindkey '^@gc' fzf-git-checkout-branch
  bindkey '^@gd' fzf-git-delete-branch
fi

