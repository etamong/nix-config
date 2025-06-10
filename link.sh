#!/bin/bash

mkdir -p $HOME/.config
SOURCE_ROOT=$(realpath $(dirname $0))

ln -s $SOURCE_ROOT/.config/home-manager $HOME/.config/home-manager
ln -s $SOURCE_ROOT/.config/nix $HOME/.config/nix
ln -s $SOURCE_ROOT/.config/.p10k.zsh $HOME/.p10k.zsh

ls -alh $HOME/.config
