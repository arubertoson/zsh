#!/bin/zsh

##
# Environment variables
#

# -U ensures each entry in these is unique (that is, discards duplicates).
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.

# ZK
export ZK_NOTEBOOK_DIR=~/notes

# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
path=(
    $path
    ~/.local/bin
    /mnt/c/Users/AlbeMar/scoop/apps/win32yank/current
)

# Add your functions to your $fpath, so you can autoload them.
fpath=(
    $ZDOTDIR/functions
    $fpath
    ~/.local/share/zsh/site-functions
)
