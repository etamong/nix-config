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
    
    definitions = mkOption {
      type = types.attrs;
      default = {};
      description = "Theme definitions with colors";
    };
  };

  config = {
    # Theme definitions with p10k colors
    themes.definitions = {
      nord = {
        name = "nord";
        p10kColors = {
          directory = 31;      # Blue
          gitClean = 76;       # Green
          gitModified = 178;   # Yellow
          gitUntracked = 76;   # Green
        };
      };
      
      monokai = {
        name = "monokai";
        p10kColors = {
          directory = 208;     # Orange
          gitClean = 118;      # Light Green
          gitModified = 227;   # Bright Yellow
          gitUntracked = 141;  # Purple
        };
      };
      
      solarized-dark = {
        name = "solarized-dark";
        p10kColors = {
          directory = 33;      # Blue
          gitClean = 64;       # Green
          gitModified = 136;   # Yellow
          gitUntracked = 37;   # Cyan
        };
      };
      
      solarized-light = {
        name = "solarized-light";
        p10kColors = {
          directory = 61;      # Blue
          gitClean = 64;       # Green
          gitModified = 136;   # Yellow
          gitUntracked = 37;   # Cyan
        };
      };
    };
  };
}
