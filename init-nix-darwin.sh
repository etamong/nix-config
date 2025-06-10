#!/bin/bash

sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
cd /etc/nix-darwin

# To use Nixpkgs 24.11:
nix flake init -t nix-darwin/nix-darwin-24.11

sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
