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
_REZ="/opt/pipeline/rez/bin/rez"
if [ ! $(_in_env ${_REZ} ${PATH}) ]; then
  PATH="${_REZ}:${PATH}"
  if [ -x "$(command -v rez)" ]; then
    export REZ_CONFIG_FILE="${HOME}/.rez/rezconfig.py"
    export REZ_REPO_PAYLOAD_DIR="/scratch/.rez/downloads"
  fi
fi

# PYENV ----------------------------------------------------------------------
_PYENV="${HOME}/.pyenv/bin"
if [[ -d "${_PYENV}" ]]; then
  # We lazy load pyenv as the init function requires some setup and we want the
  # zsh to retain 'snappy' feeling
  source "${ZDOTDIR}/functions/pyenv-lazy"
fi

# Place miniconda in front of pyenv as we are not really interested in all
# pyenv has to offer
_CONDA_ROOT='/opt/miniconda'
if [[ -d "${_CONDA_ROOT}" ]]; then
  PATH="/opt/miniconda/miniconda2/bin:/opt/miniconda/miniconda3/bin:${PATH}"
fi


# PYENV ----------------------------------------------------------------------
_NODE_YARN="${HOME}/.yarn/bin"
if [[ -d "${_NODE_YARN}" ]]; then
  _in_env ${_NODE_YARN} ${PATH} || PATH="${_NODE_YARN}:${PATH}"
fi


# CMAKE ----------------------------------------------------------------------
# TODO: make correct symlink binding
_CMAKE='/opt/cmake/bin'
if [[ -d "${_CMAKE}" ]]; then
  _in_env ${_CMAKE} ${PATH} || PATH="${_CMAKE}:${PATH}"
fi


# FINALIZE -------------------------------------------------------------------
export PATH