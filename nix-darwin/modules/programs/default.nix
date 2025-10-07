# Program-specific configurations
{ config, lib, pkgs, ... }:
{
  imports = [
    ./awsctx
    ./dev-tools
    ./ghostty
    ./git
    ./iterm2
    ./zsh
  ];
}
