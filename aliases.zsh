autoload -U zmv

zman() { PAGER="less -g -s '+/^       "$1"'" man zshall; }
rgf() { rg -g "${@:1}" --files }
zrez() { rez "${@:1}" -- zsh }
penv() { printenv "$1" | tr ":" "\n" }

# Fzy
proj() { 
  projlocs=("${(@f)$(<~/.config/plocations)}")
  expand=
  for item in "${projlocs[@]}"; do
    ppath="$(eval echo ${item})"
    if [ -d "${ppath}" ]; then
      if [ -z ${expand} ]; then
        expand="${ppath}"
      else
        expand="${expand} ${ppath}"
      fi
    fi
  done
  echo "looking in paths: ${expand}"
  cd $(find "${expand}" -maxdepth 1 -type d | fzy)
}

n() { FILE=$(find . -type f | fzy) && nvim -u "${HOME}/.vim/vimrc" $FILE }

# dotfiles
alias dots='git --git-dir=$HOME/.dots --work-tree=$HOME'
alias dots-ls='dots ls-files'
alias dots-ls-untracked='dots status -u .'

# aliases common to all shells
alias q=exit
alias clr=clear
alias sudo='sudo '

# alias ..='/usr/bin/cd ..'
# alias ...='cd ../..'
# alias ....='cd ../../..'
# alias -- -='cd -'

alias ln="${aliases[ln]:-ln} -v"  # verbose ln
alias l='ls -h1'
alias ll='ls -hl'
alias la='LC_COLLATE=C ls -hla'

# notify me before clobbering files
alias rm='rm -i -v'
alias cp='cp -i -v'
alias mv='mv -i -v'

alias gurl='curl --compressed'
alias mkdir='mkdir -p'
alias rsyncd='rsync -va --delete'   # Hard sync two directories
alias wget='wget -c'                # Resume dl if possible

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ag="noglob ag -p $XDG_CONFIG_HOME/ag/agignore"
alias rg='noglob rg'

# For example, to list all directories that contain a certain file: find . -name
# .gitattributes | map dirname
alias map="xargs -n1"


# Conviniece
alias nvim='nvim -u $HOME/.vim/vimrc'

alias wrap='tput rmam'
alias nowrap='tput smam'

