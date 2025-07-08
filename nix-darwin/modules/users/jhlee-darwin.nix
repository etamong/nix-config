# Darwin-specific configuration for jhlee
{ config, lib, pkgs, ... }:

{
  # Darwin-specific user settings
  
  # TouchID for sudo is configured in system/darwin.nix
  # Most user configurations are in home-manager
  
  # System-level user shell configuration
  programs.zsh.enable = true;
}