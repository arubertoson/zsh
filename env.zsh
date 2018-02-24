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
local _REZ=$(readlink -f "/opt/pipeline/apps/rez/latest/bin/rez")
if ( ! _in_env ${_REZ} ${PATH} ); then
  _prependenv PATH "${_REZ}"
  if [ -x "$(command -v rez)" ]; then
    export REZ_CONFIG_FILE="${HOME}/opt/pipeline/apps/rez/rezconfig.py"
    export REZ_REPO_PAYLOAD_DIR="/scratch/pipeline/downloads"
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
local _CONDA_ROOT='/opt/miniconda'
if [[ -d "${_CONDA_ROOT}" ]]; then
  for p in "miniconda2" "miniconda3"; do
    subp="${_CONDA_ROOT}/${p}/bin"
    if ( ! _in_env ${subp} ${PATH} ); then
      _prependenv PATH ${subp}
    fi
  done
fi


# PYENV ----------------------------------------------------------------------
local _NODE_YARN="${HOME}/.yarn/bin"
if [[ -d "${_NODE_YARN}" ]]; then
  _in_env ${_NODE_YARN} ${PATH} || _prependenv PATH ${_NODE_YARN}
fi


# FINALIZE -------------------------------------------------------------------
export PATH
