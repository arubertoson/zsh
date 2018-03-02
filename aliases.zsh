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
#     retians functionality from enhancd
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
# dev locations are stored in devlocations file in the user .config directory.
# It contains lines of <location> <depth> that describes how to parse it eg:
#
# # <devpaths>
#       /scratch/local 1  # will look for directories in locals
#       /storage/dev/projects 2  # will look in projects and subdirectories 
#                                  for dev locations
#
dev() { 
  local -a search_paths devlocs
  search_paths=("${(@f)$(<~/.config/devpaths)}")
  for item in "${search_paths[@]}"; do
    local -a pattern
    pattern=(${(s: :)item}) # split string at space 
    devlocs=(
      $(find "${pattern[2]}" -maxdepth "${pattern[1]}" -type d) 
      ${devlocs}
    )
  done
  cd $(printf '%s\n' "${devlocs[@]}" | fzy)
}


# ----------------------------------------------------------------------------
# aliases
# ----------------------------------------------------------------------------

alias yi='sudo yum install'
alias ys='yum search'
alias yiy='sudo yum -y install'

# aliases common to all shells
alias rg='noglob rg'
alias ..='builtin cd ..'
alias q=exit

alias ln="${aliases[ln]:-ln} -v"  # verbose ln
alias l='ls -h1'
alias ll='ls -hl'
alias la='LC_COLLATE=C ls -hla'

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
