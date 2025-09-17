
# zsh-vi-mode
export ZVM_INIT_MODE=sourcing

# We are essentially using this delayed init to set the mode we start
# a shell in. Most of the time the first thing in a new shell is a
# navigation command and that is usually handled though widgets.
function delayed-init() {
  ZVM_MODE=$ZVM_MODE_NORMAL
}

function zvm_config() {
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

  zvm_after_init_commands+=(delayed-init)
  
  ZVM_SYSTEM_CLIPBOARD_ENABLED=true
  ZVM_CLIPBOARD_COPY_CMD='win32yank.exe -i --crlf'
  ZVM_CLIPBOARD_PASTE_CMD='win32yank.exe -o --lf'
}
