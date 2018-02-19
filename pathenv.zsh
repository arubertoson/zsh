#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# Helper Functions
# ----------------------------------------------------------------------------

function _in_env() {
  if [[ ":$2:" == *":$1:"* ]]; then
      return 0
  else
      return 1
  fi
}


function _appendenv() {
  export $1="$(printenv $1):$2"
}


function _prependenv() {
  export $1="$2:$(printenv $1)"
}


# ----------------------------------------------------------------------------
# Build Path
# ----------------------------------------------------------------------------


# HOME BIN -------------------------------------------------------------------
_in_env ${XDG_BIN_HOME} ${PATH} || _prependenv PATH "${XDG_BIN_HOME}"


# REZ ------------------------------------------------------------------------
_REZ="${HOME}/.rez/bin/rez"
if [ $(_in_env ${_REZ} ${PATH}) ]; then
  PATH="${_REZ}:${PATH}"
  export REZ_CONFIG_FILE="${HOME}/.rez/rezconfig.py"
  export REZ_REPO_PAYLOAD_DIR="/scratch/.rez/downloads"
fi


# PYENV ----------------------------------------------------------------------
_PYENV="${HOME}/.pyenv/bin"
if [[ -d "${_PYENV}" ]]; then
  if [ ! $(_in_env "$_PYENV" "${PATH}") ]; then
    export PYENV_ROOT="$HOME/.pyenv/"
    PATH="${PYENV_ROOT}/bin:$PATH"
    # We init pyenv here as it further modifies the path and we want to keep it
    # fairly localized
    if [ -x "$(command -v pyenv)" ]; then
      eval "$(pyenv init -)"
      eval "$(pyenv virtualenv-init -)"
    fi
  fi
fi
# Place miniconda in front of pyenv as we are not really interested in all
# pyenv has to offer
PATH="/opt/miniconda/miniconda2/bin:/opt/miniconda/miniconda3/bin:${PATH}"


# PYENV ----------------------------------------------------------------------
_NODE_YARN="${HOME}/.yarn/bin"
_in_env ${_NODE_YARN} ${PATH} || PATH="${_NODE_YARN}:${PATH}"


# CMAKE ----------------------------------------------------------------------
# TODO: make correct symlink binding
_CMAKE='/opt/cmake/bin'
_in_env ${_CMAKE} ${PATH} || PATH="${_CMAKE}:${PATH}"


# FINALIZE -------------------------------------------------------------------
export PATH
