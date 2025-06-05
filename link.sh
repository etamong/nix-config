#!/bin/bash

mkdir -p $HOME/.config
SOURCE_ROOT=$(realpath $(dirname $0))

ln -s $SOURCE_ROOT/.config/home-manager $HOME/.config/home-manager
ln -s $SOURCE_ROOT/.config/nix $HOME/.config/nix

ls -alh $HOME/.config
