#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# Zgen for loading plugins
# ----------------------------------------------------------------------------
export ZGEN_AUTOLOAD_COMPINIT=0
AUTOPAIR_INHIBIT_INIT=1

_load_repo tarjoilija/zgen $ZGEN_DIR zgen.zsh
if ! zgen saved; then
  echo "Creating zgen save"

  zgen load hlissner/zsh-autopair autopair.zsh develop
  zgen load zsh-users/zsh-history-substring-search
  zgen load zdharma/history-search-multi-word
  zgen load zsh-users/zsh-completions src
  zgen load b4b4r07/enhancd init.sh

  if [[ -z $SSH_CONNECTION ]]; then
    zgen load zdharma/fast-syntax-highlighting
  fi

  zgen save
fi

# ----------------------------------------------------------------------------
# Source custom setup scripts
# ----------------------------------------------------------------------------

source "${ZDOTDIR}/config.zsh"
source "${ZDOTDIR}/completions.zsh"
source "${ZDOTDIR}/keymaps.zsh"
source "${ZDOTDIR}/prompt.zsh"

# ----------------------------------------------------------------------------
# Load tab completion and other setup
# ----------------------------------------------------------------------------

# Autopair needs to be initilized before compinit 
autopair-init

# Enable tab completion and cache location
autoload -Uz compinit
if [[ -n ${ZSH_CACHE}/.zcompdump(#qN.mh+24) ]]; then
  compinit -d ${ZSH_CACHE}/.zcompdump
else
  compinit -C
fi

# TODO: Needs to be better handled
eval "$(dircolors ${ZDOTDIR}/.dircolors)"

# Aliases should be sourced last as it can be overridden by other plugins
source "${ZDOTDIR}/aliases.zsh"
