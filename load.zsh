#!/usr/bin/env zsh

# file should be moved to 

# Autopair needs to be initilized before compinit 
autopair-init

# Enable tab completion and cache location
autoload -Uz compinit && compinit -d $ZSH_CACHE/zcompdump

# TODO: Needs to be better handled
eval "$(dircolors ${ZDOTDIR}/.dircolors)"
