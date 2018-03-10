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
local _REZ="$(readlink -f /opt/pipeline/rez/2.18.0)"
if [[ -d "${_REZ}" ]]; then
  local rezbin="${_REZ}/bin/rez"
  _in_env ${rezbin} ${PATH} || _prependenv PATH ${rezbin} 
  if [ -x "$(command -v rez)" ]; then
    export REZ_CONFIG_FILE=$(dirname "${_REZ}")/rezconfig.py
    export REZ_REPO_PAYLOAD_DIR="/mnt/software/archives"
  fi
fi

# PYENV ----------------------------------------------------------------------
local _PYENV="${PYENV_ROOT:-${HOME}/.pyenv}/bin"
if [[ -d "${_PYENV}" ]]; then
  # We lazy load pyenv as the init function requires some setup and we want the
  # zsh to retain 'snappy' feeling
  source "${ZDOTDIR}/functions/pyenv-lazy"
fi

# Place miniconda in front of pyenv as we are not really interested in all
# pyenv has to offer
local _CONDA_ROOT='/opt/pipeline/conda/bin'
if [[ -d "${_CONDA_ROOT}" ]]; then
  _in_env ${_CONDA_ROOT} ${PATH} || _prependenv PATH ${_CONDA_ROOT}
fi


# PYENV ----------------------------------------------------------------------
local _NODE_YARN="${HOME}/.yarn/bin"
if [[ -d "${_NODE_YARN}" ]]; then
  _in_env ${_NODE_YARN} ${PATH} || _prependenv PATH ${_NODE_YARN}
fi

# PYENV ----------------------------------------------------------------------
local _KITTY="/opt/pipeline/kitty/bin"
if [ -d "${_KITTY}" ]; then
  _in_env ${_KITTY} ${PATH} || _prependenv PATH ${_KITTY}
fi

# FINALIZE -------------------------------------------------------------------
export PATH
