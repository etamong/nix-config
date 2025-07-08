# Vim configuration module
{ config, lib, pkgs, ... }:

with lib;

{
  options.programs.vim.enable = mkEnableOption "Vim configuration";

  config = mkIf config.programs.vim.enable {
    # Vim configuration will be moved here
  };
}