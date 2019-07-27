#!/usr/bin/env zsh

autoload -U zmv

# ----------------------------------------------------------------------------
# Alias Functions
# ----------------------------------------------------------------------------

rg() {
# the -f flag now behaves like a glob by default
#   usage:
#     "rg -f **/*.zsh"
#   
  if [ ! -z "$1" ] && [ $1 == '-f' ];then
    command rg -g "${@:2}" --files --hidden
  else
    command rg "$@"
  fi
}

# cd() {
# # enhancd override
#   _cd "$@"
# }


# ----------------------------------------------------------------------------
# aliases
# ----------------------------------------------------------------------------

alias sudoenv='sudo env "PATH=$PATH"'

alias yi='sudo yum install'
alias ys='yum search'
alias yiy='sudo yum -y install'

# aliases common to all shells
# alias rg='noglob rg'
alias ..='builtin cd ..'
alias q=exit

alias ln="${aliases[ln]:-ln} -v"  # verbose ln
alias l='ls -ha1 --color=auto'
alias ll='ls -hal --color=auto'
alias la='LC_COLLATE=C ls -hal --color=auto'

# notify me before clobbering files
alias rm='rm -i -v'
alias cp='cp -i -v'
alias mv='mv -i -v'

alias mkdir='mkdir -p'
alias rsyncd='rsync -va --delete'   # Hard sync two directories
alias wget='wget -c'                # Resume dl if possible

# For example, to list all directories that contain a certain file: find . -name
# .gitattributes | map dirname
alias map="xargs -n1"

# Wrapping for terminal
alias wrap='tput rmam'
alias nowrap='tput smam'
