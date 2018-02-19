#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# Defines runtime environment
# ----------------------------------------------------------------------------

export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_DATA_HOME="${HOME}/.local/share"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZGEN_DIR="$XDG_CACHE_HOME/zgen"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"

export REZ_CONFIG_FILE="${HOME}/.rez/rezconfig.py"
export REZ_REPO_PAYLOAD_DIR="/scratch/.rez/downloads"

export SHELL=$(command -v zsh)
export LANG=${LANG:-en_US.UTF-8}
export PAGER=less
export LESS='-R -i -w -M -z-4'
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"

# Test 
export VISUAL=nvim
export EDITOR="$VISUAL"


# ----------------------------------------------------------------------------
# Setup and build PATH
# ----------------------------------------------------------------------------

if [[ -z "${REZ_RESOLVE}" ]] ; then
  [[ ":$PATH:" != *":${XDG_BIN_HOME}:"* ]] && PATH="${XDG_BIN_HOME}:${PATH}"
  [[ ":$PATH:" != *":${HOME}/.rez/bin/rez:"* ]] && PATH="${HOME}/.rez/bin/rez:${PATH}"

  # Should be moved linked from /usr/local/bin
  [[ ":$PATH:" != *":/opt/cmake/bin:"* ]] && PATH="/opt/cmake/bin:${PATH}"

  # Miniconda/Pyenv pythonpath for pymel/mayacmds help
  # TODO: Should be moved to another location as it's only relevant when
  # developing certain tools.
  export PYTHONPATH="$PYTHONPATH:$HOME/python-dev/extras/python/autodesk/"

  # We need to set pyenv first as we're only utilizing pipsi and other tools
  # needing virtualenv to work with pyenv
  if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv/"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
  # Place miniconda python before pyenv after pyenv is done with setup, pyenv 
  # does it's own thing after init is run
  PATH="/opt/miniconda/miniconda2/bin:${PATH}"
  
  # Export custom PATH
  export PATH
fi


# ----------------------------------------------------------------------------
# Custom Functions
# ----------------------------------------------------------------------------

function _is_callable {
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null || return 1
  done
}

function _load_repo {
  _get_repo "$1" "$2" && source "$2/$3" || >&2 echo "Failed to load $1"
}


function _get_repo {
  local target=$1
  local dest=$2
  if [[ ! -d $dest ]]; then
    url=https://github.com/$target
    git clone --recursive "$url" "$dest" || return 1
  fi
}


function _cache_clear {
  command rm -rfv $XDG_CACHE_HOME/${SHELL##*/}/*;
}

