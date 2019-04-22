#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# Zgen for loading plugins
# ----------------------------------------------------------------------------

# export ZGEN_AUTOLOAD_COMPINIT=0
AUTOPAIR_INHIBIT_INIT=1

# XXX: move to a better location, how to add variables zgen
ENHANCD_COMMAND='_cd' 

_load_repo tarjoilija/zgen $ZGEN_DIR zgen.zsh
if ! zgen saved; then
  echo "Creating zgen save"

  zgen load hlissner/zsh-autopair autopair.zsh develop
  zgen load zsh-users/zsh-history-substring-search
  zgen load zdharma/history-search-multi-word
  zgen load zsh-users/zsh-completions src

  zgen load supercrabtree/k
  zgen load ytet5uy4/fzf-widgets init.zsh

  if [[ -z $SSH_CONNECTION ]]; then
    zgen load zdharma/fast-syntax-highlighting
  fi

  zgen save
fi


# ----------------------------------------------------------------------------
# CUSTOM SCRIPTS & PATH
#
# Aliases should be sourced last, otherwise we run the risk of letting other
# plugins override functionality
# ----------------------------------------------------------------------------

source "${ZDOTDIR}/locales/${_BASE_LOCALE}"
source "${ZDOTDIR}/config.zsh"
source "${ZDOTDIR}/completions.zsh"
source "${ZDOTDIR}/keymaps.zsh"
source "${ZDOTDIR}/prompt.zsh"


# ----------------------------------------------------------------------------
# COLORS, COMPINIT & AUTOPAIR
#
# Load tab completion and other setup, order is important
# ----------------------------------------------------------------------------

# Autopair needs to be initilized before compinit 
autopair-init

# enhancd is tightly bound to compinit and it's hard to init without loading 
# later it
zgen load b4b4r07/enhancd init.sh

# XXX: Needs to be better handled
eval "$(dircolors ${ZDOTDIR}/.dircolors)"


# ----------------------------------------------------------------------------
# ALIASES
#
# Aliases should be sourced last, otherwise we run the risk of letting other
# plugins override functionality
# ----------------------------------------------------------------------------

source "${ZDOTDIR}/aliases.zsh"

