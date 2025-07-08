# Development tools configuration
{ config, lib, pkgs, ... }:

with lib;

{
  options.programs.dev-tools.enable = mkEnableOption "Development tools configuration";

  config = mkIf config.programs.dev-tools.enable {
    # Development tools configuration will be moved here
  };
}