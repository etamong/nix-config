#!/bin/bash

mkdir -p $HOME/.config
SOURCE_ROOT=$(realpath $(dirname $0))

# Link home-manager configuration
ln -s $SOURCE_ROOT/.config/home-manager $HOME/.config/home-manager

# Link nix configuration
ln -s $SOURCE_ROOT/.config/nix $HOME/.config/nix

# nix-darwin configuration is managed by init-nix-darwin.sh
# (stored in /etc/nix-darwin, requires sudo access)

# Link powerlevel10k configuration
ln -s $SOURCE_ROOT/.config/.p10k.zsh $HOME/.p10k.zsh

echo "Linked configurations:"
ls -alh $HOME/.config

echo "You can now:"
echo "- Run 'home-manager switch' for user-level changes"
echo "- Run './init-nix-darwin.sh' for system-level setup"
echo "- Edit home-manager configs in this repository and run 'home-manager switch'"
echo "- Edit nix-darwin configs in .config/nix-darwin/ and re-run './init-nix-darwin.sh'"
