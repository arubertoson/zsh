#!/usr/bin/env zsh

# 
# Loosly inspired by pure <https://github.com/sindresorhus/pure>
#


# Prompt symbols
VINSYM="«"
VIISYM=">"
GITDIRTY="*"


# Make sure necessary version control information is available
_load_vcs_info() {
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' use-simple true
	# only export two msg variables from vcs_info
	zstyle ':vcs_info:*' max-exports 2
	# export branch (%b) and git toplevel (%R)
	zstyle ':vcs_info:git*' formats '%b' '%R'
	zstyle ':vcs_info:git*' actionformats '%b|%a' '%R'
}


# Update prompt symbol depending on insert mode
zle-keymap-select() {
  case $KEYMAP in
    (vicmd)      
      PROMPT_SYMBOL="%F{orange}${VINSYM} "
    ;;
    (main|viins) 
      # Prompt depth is shown by 
      prompt_char=$(printf "${VIISYM}%.0s" {1..$SHLVL})
      PROMPT_SYMBOL="${prompt_char} "
    ;;
  esac
  zle && zle reset-prompt && zle -R
}


_is_git_dirty() {
  # We return the result of the last executed command with $? - if hte output
  # of the git command is not empty we know it's dirty
  test -n "$(command git status --porcelain --ignore-submodules -unormal)"
  return $?
}


# render right rprompt of right side with given parts
_rprompt_render() {
  local -a _rp1

  # Provide $PWD for right prompt
  _rp1+=("%F{blue}%~")

  # I want to be able to tell at a glance the status of the git repo, a simple
  # colorswitch and marker goes a long way without complicating it.
  local git_color=green prompt_git_dirty
  if [[ -n $_vcs_info[top] ]]; then
    if ( $(_is_git_dirty) ); then 
      git_color=red
      prompt_git_dirty="${GITDIRTY}"
    fi
    _rp1+=("%F{$git_color}${_vcs_info[branch]}${prompt_git_dirty}%f")
  fi

  # Join prompt parts into the rprompt
  RPROMPT="${(j. .)_rp1}"
}


# Hook into the precmd we render the RPROMPT from here as it has dependencies
# on queires from PWD and other parts.
_hook_precmd() {
  # Fetch git information
  vcs_info

	_vcs_info[top]=$vcs_info_msg_1_
	_vcs_info[branch]=$vcs_info_msg_0_
  
  # Render rprompt when necessary information is configured
  _rprompt_render

  # Add an extra newline when the prompt redraws for a new command. It feels
  # cleaner
  [[ -n $PROMPT_DONE ]] && print ""; PROMPT_DONE=1
}


# Init prompt with config and global variables
prompt_init(){
  typeset -gA _vcs_info

  setopt promptsubst
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  add-zsh-hook precmd _hook_precmd

  zle -N zle-keymap-select
  zle -A zle-keymap-select zle-line-init

  _load_vcs_info

  local _users _uname 
  _users=(macke malbertsson)
  # If unexpected user show username
  if (( ! ${_users[(I)$(whoami)]} ));then
    _uname=("%n")
	# show username if root, with username in white
    [[ $UID -eq 0 ]] && _uname=("%F{226}%n%f")
  fi

	# show username:host if logged in through SSH
  [[ "$SSH_CONNECTION" != '' ]] && _uname+=('%F{122}:%m%f')
  _uname+=(' ')

  # Need to give the PROMPT a starting point
  PROMPT="${(j..)_uname:- }"'%(?.%F{green}.%F{red})${PROMPT_SYMBOL:-$VIISYM }%f'
}


prompt_init "$@"
