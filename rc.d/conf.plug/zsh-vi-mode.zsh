
# We ensure that we start the shell in normal mode to
# give access to hotkeys that are mostly used when 
# entering a shell.
zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL
}

# zsh-vi-mode
export ZVM_INIT_MODE=sourcing
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk