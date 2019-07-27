# ----------------------------------------------------------------------------
# Zgen for loading plugins
# ----------------------------------------------------------------------------

export ZGEN_DIR="$XDG_CACHE_HOME/zgen"

ZGEN_AUTOLOAD_COMPINIT=0

_load_repo tarjoilija/zgen $ZGEN_DIR zgen.zsh
if ! zgen saved; then
  echo "Creating zgen save"

  zgen load hlissner/zsh-autopair autopair.zsh develop
  zgen load ytet5uy4/fzf-widgets init.zsh

  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions src

  zgen load esc/conda-zsh-completion
  zgen load wfxr/forgit

  # XXX: Currently broken
  # if [[ -z $SSH_CONNECTION ]]; then
  #   zgen load zdharma/fast-syntax-highlighting
  # fi

  zgen save
fi
