# Program-specific configurations
{ config, lib, pkgs, ... }:
{
  imports = [
    ./vim
    ./zsh
    ./git
    ./dev-tools
  ];
}