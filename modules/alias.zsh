#!/usr/bin/env zsh

autoload -U zmv

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

export DOCKER_REPO_PREFIX=arubertoson

imaya() {
  docker run -it --rm \
    --name imayapy \
    ${DOCKER_REPO_PREFIX}/maya -m IPython
}

# ----------------------------------------------------------------------------
# aliases
# ----------------------------------------------------------------------------

alias simple-nvim='XDG_CONFIG_HOME="~/.config/nvim-simple" XDG_DATA_HOME="$XDG_CACHE_PATH/nvim-simple" nvim'

alias sudoenv='sudo env "PATH=$PATH"'

alias yi='sudo yum install'
alias ys='yum search'
alias yiy='sudo yum -y install'

# aliases common to all shells
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

# https://github.com/pypa/pipenv/issues/1929#issuecomment-609848370
# alias env VIRTUALENV_COPIES=1 pipenv install
