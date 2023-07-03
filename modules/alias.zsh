#!/usr/bin/env zsh

autoload -U zmv

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

imaya() {
  export DOCKER_REPO_PREFIX=arubertoson
  docker run -it --rm \
    --name imayapy \
    ${DOCKER_REPO_PREFIX}/maya -m IPython
}

# ----------------------------------------------------------------------------
# aliases
# ----------------------------------------------------------------------------

# Googler custom searches
# alias googler="ddgr" #Cli quick googler search
# alias @g='googler -x -n 4 $@'
# alias @w='googler -x -n 4 -w en.wikipedia.org $@'
# alias @rd='googler -x -n 4 --url-handler ttrv -w reddit.com "$@"'
# alias @y='googler -r "us-en" -n 4 --url-handler mpv -w youtube.com "$@"'
# alias @git='googler -n 4 -w github.com $@'
# alias @so='so $@'

alias fd='fdfind'

alias simple-nvim='XDG_CONFIG_HOME="~/.config/nvim-simple" XDG_DATA_HOME="$XDG_CACHE_PATH/nvim-simple" nvim'

# alias sudoenv='sudo env "PATH=$PATH"'
# alias yi='sudo yum install'
# alias ys='yum search'
# alias yiy='sudo yum -y install'

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