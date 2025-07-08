# User-specific configuration for jhlee
{ config, lib, pkgs, ... }:

{
  # Enable program modules
  programs.zsh.enablePowerlevel10k = true;
  programs.dev-tools.enable = true;
  
  # User-specific theme selection
  themes.selected = "nord";
}