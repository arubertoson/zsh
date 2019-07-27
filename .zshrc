#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# CUSTOM MODULES
#
# Aliases should be sourced last, otherwise we run the risk of letting other
# plugins override functionality
# ----------------------------------------------------------------------------

# Order is important
_modules=(
  "plugin"
  "prompt"
  "keymap"
  "fzf"
  "docker"
  "alias"
  "completion"
)
# XXX: extract to function
for m in ${_modules[@]}; do
  file="${ZDOTDIR}/modules/${m}.zsh"
  if [[ -a "${file}" ]]; then
    source "${file}"
  fi
done


# ----------------------------------------------------------------------------
# CUSTOM LOCALE & FUNCTIONS
#
# Aliases should be sourced last, otherwise we run the risk of letting other
# plugins override functionality
# ----------------------------------------------------------------------------

source "${ZDOTDIR}/locales/${_BASE_LOCALE}"

# Autoload Functions
funcs="${ZDOTDIR}/functions"
# XXX: extract to function
fpath=("${funcs}" "${fpath[@]}")
for func in ${funcs}; do
  autoload -Uz "${func}"
done

# ----------------------------------------------------------------------------
# COLORS, COMPINIT & AUTOPAIR
#
# Load tab completion and other setup, order is important
# ----------------------------------------------------------------------------

# Autopair needs to be initilized before compinit 
autopair-init
eval "$(dircolors ${ZDOTDIR}/.dircolors)"

autoload -Uz compinit && \
   compinit -C -d $XDG_CACHE_HOME/zcompdump
