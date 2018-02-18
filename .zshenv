#!/usr/bin/env zsh
#
# Defines runtime environment
#

# source usr environment
#
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_DATA_HOME="${HOME}/.local/share"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
export ZGEN_DIR="$XDG_CACHE_HOME/zgen"


# Helper function for member lookup in enviornment variables
function _is_env_member() {
  if [[ ":$2:" != *":$1:"* ]]; then
      return 0
  else
      return 1
  fi
}

# home bin
_is_env_member ${XDG_BIN_HOME} ${PATH} && PATH="${XDG_BIN_HOME}:${PATH}"

# Rez
_REZ="${HOME}/.rez/bin/rez"
export REZ_CONFIG_FILE="${HOME}/.rez/rezconfig.py"
export REZ_REPO_PAYLOAD_DIR="/scratch/.rez/downloads"
_is_env_member ${_REZ} ${PATH} && PATH="${_REZ}:${PATH}"

# yarn
_NODE_YARN="${HOME}/.yarn/bin"
_is_env_member ${_NODE_YARN} ${PATH} && PATH="${_NODE_YARN}:${PATH}"

# Pyenv is a python version handler
_PYENV="${HOME}/.pyenv/bin"
if [[ -d "${_PYENV}" ]]; then
  if [ ! $(_is_env_member "$_PYENV" "${PATH}") ]; then
    export PYENV_ROOT="$HOME/.pyenv/"
    PATH="${PYENV_ROOT}/bin:$PATH"
  fi
fi

# cmake
# TODO: make correct symlink binding
_CMAKE='/opt/cmake/bin'
_is_env_member ${_CMAKE} ${PATH} && PATH="${_CMAKE}:${PATH}"


# Finalize path
export PATH

fpath=(${ZDOTDIR}/completion $fpath)

#
# Environment variables
#
export SHELL=$(command -v zsh)
export LANG=${LANG:-en_US.UTF-8}
export PAGER=less
export LESS='-R -i -w -M -z-4'
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"

# Test
export VISUAL=nvim
export EDITOR="$VISUAL"


#
# Functions
#

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


