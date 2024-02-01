#!/bin/bash

# Set the repository URL
repo_url="git@github.com:arubertoson/zsh.git"

# Extract the username, hostname, and repository name
username=$(echo $repo_url | cut -d':' -f2 | cut -d'/' -f1)
hostname=$(echo $repo_url | cut -d':' -f1 | cut -d'@' -f2)
repo_name=$(echo $repo_url | cut -d'/' -f2 | cut -d'.' -f1)

# Set the dev path and clone the repository
dev_path="$HOME/dev/$hostname/$username/$repo_name"
mkdir -p $dev_path
git clone $repo_url $dev_path

# Create the symlink for the .zshenv file
ln -sf $dev_path/.zshenv $HOME/.zshenv

# Create the symlink for the zsh config directory
# mkdir -p $HOME/.config/zsh
ln -sf $dev_path $HOME/.config/zsh

# Check if zsh is installed, and if not, install it
if ! command -v zsh &> /dev/null; then
    echo "zsh could not be found, attempting to install..."
    sudo apt update
    sudo apt install zsh -y
fi

# Set zsh as the default shell
chsh -s $(which zsh)
