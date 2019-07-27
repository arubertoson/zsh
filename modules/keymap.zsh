# -----------------------------------------------------------------------------
# KeyMaps
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


