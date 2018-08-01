# -----------------------------------------------------------------------------
# KeyMaps
#
# author: Marcus Albertsson
# -----------------------------------------------------------------------------

# The surround module wasn't working if KEYTIMEOUT was <= 10. Specifically,
# (delete|change)-surround immediately abort into insert mode if KEYTIMEOUT <=
# 8. If <= 10, then add-surround does the same. At 11, all these issues vanish.
# Very strange!
export KEYTIMEOUT=15

autoload -U is-at-least

# -----------------------------------------------------------------------------
# Vi Mode
# -----------------------------------------------------------------------------

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins ' ' magic-space

# Open current prompt in external editor
autoload -Uz edit-command-line; zle -N edit-command-line
bindkey '^@q' edit-command-line

bindkey -M viins '^w' backward-kill-word
bindkey -M vicmd 'H'  run-help

# Shift + Tab
bindkey -M viins '^[[Z' reverse-menu-complete


# ----------------------------------------------------------------------------
# Surround
# ----------------------------------------------------------------------------

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround

# <5.0.8 doesn't have visual map
if is-at-least 5.0.8; then
  bindkey -M visual S add-surround

  # add vimmish text-object support to zsh
  autoload -U select-quoted; zle -N select-quoted
  for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
      bindkey -M $m $c select-quoted
    done
  done
  autoload -U select-bracketed; zle -N select-bracketed
  for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
      bindkey -M $m $c select-bracketed
    done
  done
fi


# ----------------------------------------------------------------------------
# Fzf widget
# ----------------------------------------------------------------------------

# Only Continue if fzf is available
if (! command -v fzf &> /dev/null); then
  echo "fzf is not available - install if you want to activate fzf widgets"
  return
fi


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

# Expose zle functions
zle -N fzf-select-job
zle -N fzf-icat
zle -N fzf-echo-env
zle -N fzf-change-directory


# Custom Functions bindings
bindkey "^@i" fzf-icat
bindkey "^@j" fzf-select-job
bindkey "^@p" fzf-echo-env
bindkey "^@t" fzf-change-directory


# Fzf-widget plugin
if [ -n "$(declare -fF fzf-select-widget)" ]; then
  bindkey '^@r' fzf-select-widget
  bindkey '^@h' fzf-insert-history
  bindkey '^@f' fzf-edit-files

  bindkey '^@]' fzf-git-change-repository
  bindkey '^@ga' fzf-git-add-files
  bindkey '^@gc' fzf-git-checkout-branch
  bindkey '^@gd' fzf-git-delete-branch
fi

