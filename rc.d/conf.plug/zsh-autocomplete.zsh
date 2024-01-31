
zstyle '*:compinit' arguments -D -i -u -C -w

# The Zsh Autocomplete plugin sends *a lot* of characters to your terminal.
# This is fine locally on modern machines, but if you're working through a slow
# ssh connection, you might want to add a slight delay before the
# autocompletion kicks in:
zstyle ':autocomplete:*' delay 0.5  # seconds

# Each widget should try to insert the longest prefix initially, that will complete
# to all completions shown, if any, then add the following:
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'

# Modifying this list will change when a space is inserted. If you change the list
#  to '*', a space is always inserted. If you put no elements in the list, then
#  a space is never inserted.
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands


# By default, Autocomplete let the history menu fill half of the screen, and limits
# autocompletion and history search to maximum of 16 lines. You can change these
# limits as follows:

# Autocompletion
zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 3 )) )'

# Override history search.
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8

# History menu.
zstyle ':autocomplete:history-search-backward:*' list-lines 256

# Make Tab and Shift+Tab cycle completions on the command line
# bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# Make Tab go straight to the menu and cycle there
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# By default, pressing Enter in the menu search exits the search and pressing it
# otherwise in the menu exits the menu. If you instead want to make Enter always
#  submit the command line, use the following:
bindkey -M menuselect '\r' .accept-line