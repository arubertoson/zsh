#!/bin/zsh
#
# This file, .zshenv, is the first file sourced by zsh for EACH shell, whether
# it's interactive or not. This includes non-interactive sub-shells! So, put
# as little in this file as possible, to avoid performance impact.



# disable globals rcs, we want control of what is in our environment
unsetopt GLOBAL_RCS

# Disable global compinit: Optimizes zsh startup by skipping global 
# autocompletion initialization. We are handling compinit ourselves.
skip_global_compinit=1

# Ensure XDG Base directory specification is respected
HOME_LOCAL="${HOME}/.local"

# Set XDG (XDG Base Directory Specification) environment variables. In Ubuntu, as
# in many Linux distributions, the XDG environment variables are not always 
# explicitly set by default. 
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME_LOCAL}/share"

# Extended XDG with some custom locations
export XDG_BIN_HOME="${HOME_LOCAL}/bin"
export XDG_APP_HOME="${HOME_LOCAL}/package"
export XDG_DEV_HOME="${HOME}/dev"
export XDG_WINDOWS_DEV_HOME="/mnt/c/Users/Macke/dev"

export EDITOR="nvim"

# Tell zsh where to look for our dotfiles. By default, Zsh will look for 
# dotfiles in $HOME (and find this file), but once $ZDOTDIR is defined, it will 
# start looking in that dir instead.
ZDOTDIR=$(realpath "${XDG_CONFIG_HOME}/zsh")
ZSH_CACHE="${XDG_CACHE_HOME}/zsh"