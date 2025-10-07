# Program-specific configurations
{ config, lib, pkgs, ... }:
{
  imports = [
    ./zsh
    ./git
    ./dev-tools
    ./iterm2
    ./ghostty
    ./awsctx
  ];
}
