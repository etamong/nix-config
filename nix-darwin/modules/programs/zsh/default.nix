# ZSH configuration module
{ config, lib, pkgs, ... }:

with lib;

{
  options.programs.zsh.enablePowerlevel10k = mkEnableOption "Powerlevel10k theme for ZSH";

  config = mkIf config.programs.zsh.enablePowerlevel10k {
    # ZSH/Powerlevel10k configuration will be moved here
  };
}