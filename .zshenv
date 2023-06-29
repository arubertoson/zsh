#!/usr/bin/env zsh

# ----------------------------------------------------------------------------
# Initial Setup
# ----------------------------------------------------------------------------

# disable globals rcs, we want control of what is in our environment
unsetopt GLOBAL_RCS

# ----------------------------------------------------------------------------
# Defines runtime environment
# ----------------------------------------------------------------------------

export _BASE_LOCALE='home'
export _BASE_HOME="${HOME}/.local"

# Use XDG variables to set our environment
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_BIN_HOME="${_BASE_HOME}/bin"
export XDG_DATA_HOME="${_BASE_HOME}/share"
export XDG_APP_HOME="${_BASE_HOME}/package"

# Move ZDOTDIR to .config to reduce dot file pollution
export ZDOTDIR=$(realpath "$XDG_CONFIG_HOME/zsh")
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"

export SHELL=$(command -v zsh)
export LANG=${LANG:-en_US.UTF-8}
# export PAGER="page -q 90000"
# export MANPAGER='nvim +Man!'
# export MANPAGER="page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'"

if command -v "nvr" &>/dev/null && [ -n "${NVIM_LISTEN_ADDRESS}" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'

    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    # XXX: Currently not working as expected
    export VISUAL=nvim
    export EDITOR=nvim
fi


# ----------------------------------------------------------------------------
# Custom Functions
# ----------------------------------------------------------------------------

function _drop_cache {
    sudo su -c "sync; sudo echo 3 > /proc/sys/vm/drop_caches; sudo touch /root/drop_caches_last_run"
}

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


function _pathclean() {
  export $1=$(printenv $1) | sed 's/:/\n/g' | uniq | tr "\n" ":"
}

function _git_pull() {
  cd $1 && git pull && cd -
}

