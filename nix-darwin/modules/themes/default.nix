# Theme management system
{ config, lib, pkgs, ... }:

with lib;

{
  options.themes = {
    selected = mkOption {
      type = types.str;
      default = "nord";
      description = "Selected theme for the system";
    };
  };

  config = {
    # Theme configurations will be implemented here
  };
}