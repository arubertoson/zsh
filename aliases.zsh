autoload -U zmv

# ----------------------------------------------------------------------------
# Alias Functions
# ----------------------------------------------------------------------------


# Launch man zshall with a search
#
# usage:
#
#   zman printf
#     will run "man zshall" and make a direct search for faster navigation
zman() { PAGER="less -g -s '+/^       "$1"'" man zshall; }


# Output environment variable
#
# usage:
#
#   "penv ${PATH:- PATH}" :
#     will output PATH with every entry delimited by a newline
#
penv() { 
  local output
  if (( ${+1} )); then
    output=$(printenv "$1")
    if [ -z "${output}" ]; then
      output=$(echo "$1")
    fi
  fi
  echo $output | tr ":" "\n" 
}


# Nvim overrides
#
# usage:
#
#     nvim -- :
#       start a nvim session with default configurations
#     nvim .  :
#       search recursivly for a file that nvim will open
#
nvim() {
  if [ ! -z "$1" ]; then
    if [ $1 == '--' ]; then
      command nvim "${@:2}" && return
    fi

    if [ $1 == '.' ]; then
      file=$(rg -f **/* | fzy) || return
      command nvim "${file}" -u "${HOME}/.vim/vimrc" "$@" && return
    fi
  fi
  command nvim -u "${HOME}/.vim/vimrc" "$@"
}


# rg override
#
# normally "rg -f <filename>" will search for the given pattern in the -f files.
# I've simplified it by letting rg act as if I'm doing the "rg -g <pattern>
# --files" by simply inputting "rg -f <pattern>"
#
# usage:
#
#   "rg -f **/*.zsh" :
#     search recursivly for all .zsh files
#   
rg() {
  if [ ! -z "$1" ] && [ $1 == '-f' ];then
    command rg -g "${@:2}" --files --hidden
  else
    command rg "$@"
  fi
}


# cd override
#
# _cd is an alias pointing to the enhancd plugin, it does not support custom
# arguments, this acts as a wrapper to give me the flexibility I want.
# 
# usage:
#   
#   "cd ." :
#     collects paths recursivly and resolves a path with fzy
#   "cd" :
#     retains functionality from enhancd
#
cd() {
  if [ ! -z "$1" ] && [ $1 == '.' ]; then
    cd $(find -type d -printf '%P\n'| fzy)
  else
    _cd "$@"
  fi
}


# Navigate to dev locations.
#
# dev locations are stored in devpaths file in the XDG_CONFIG_HOME directory.
# It contains lines of <location> that the function will parse for .git repos,
# the search will be cached and if you want a refresh you'll have to give the 
# -r flags (reset).
#
# # <devpaths>
#       /scratch/local 1  # will look for directories in locals
#       /storage/dev/projects 2  # will look in projects and subdirectories 
#                                  for dev locations
#
dev() { 
  [ ! -f "${XDG_CONFIG_HOME}/devpaths" ] && echo "Create devpaths" && return

  local -a search_paths devlocs
  local cache="${XDG_CACHE_HOME}/devpaths"
  if [ "$1" = "-r" ] || [ ! -f "${cache}" ]; then
    search_paths=("${(@f)$(<~/.config/devpaths)}")
    for item in "${search_paths[@]}"; do
      if [ -d "${item}" ]; then 
        devlocs=(
          $(find ${item} -name .git -type d -prune -exec dirname {} \;)
          ${devlocs}
        )
      fi
    done

    # Empty cache file, we don't want to append to it
    : > ${cache}
    # Setup a cache that can be reset by giving -r as argument
    [ "${#devlocs[@]}" -eq 0 ] || printf "%s\n" "${devlocs[@]}" > ${cache}
  fi

  # Need to directo to builtin cd as we have overridden it with enhancd
  builtin cd $(cat ${cache} | fzy)
}


# ----------------------------------------------------------------------------
# aliases
# ----------------------------------------------------------------------------

alias sudoenv='sudo env "PATH=$PATH"'

alias yi='sudo yum install'
alias ys='yum search'
alias yiy='sudo yum -y install'

# aliases common to all shells
alias rg='noglob rg'
alias ..='builtin cd ..'
alias q=exit

alias ln="${aliases[ln]:-ln} -v"  # verbose ln
alias l='ls -h1 --color=auto'
alias ll='ls -hl --color=auto'
alias la='LC_COLLATE=C ls -hla --color=auto'

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
alias wrap='tput smam'
alias nowrap='tput rmam'
