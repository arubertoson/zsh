#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# Zgen for loading plugins
# ----------------------------------------------------------------------------
export ZGEN_AUTOLOAD_COMPINIT=0
AUTOPAIR_INHIBIT_INIT=1

# Install zgen from repo
_load_repo tarjoilija/zgen $ZGEN_DIR zgen.zsh
if ! zgen saved; then
  echo "Creating zgen save"
  _cache_clear

  zgen load hlissner/zsh-autopair autopair.zsh develop
  zgen load zsh-users/zsh-history-substring-search
  zgen load zdharma/history-search-multi-word
  zgen load zsh-users/zsh-completions src
  zgen load zdharma/fast-syntax-highlighting
  # zgen load junegunn/fzf shell
  # zgen load rupa/z z.sh
  zgen load b4b4r07/enhancd init.sh

  zgen save
fi

# ----------------------------------------------------------------------------
# Source custom setup scripts
# ----------------------------------------------------------------------------
source "${ZDOTDIR}/config.zsh"
source "${ZDOTDIR}/completions.zsh"
source "${ZDOTDIR}/keymaps.zsh"
source "${ZDOTDIR}/prompt.zsh"

# All setup outside of above should be done in load.
source "${ZDOTDIR}/load.zsh"
# Aliases should be sourced last as it can be overridden by other plugins
# otherwise
source "${ZDOTDIR}/aliases.zsh"
