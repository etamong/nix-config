{ config, lib, pkgs, ... }:

{
  # iTerm2 configuration using home-manager
  home-manager.users.jhlee = {
    programs.iterm2 = {
      enable = true;
      
      # Default profile configuration
      profiles = {
        "Default" = {
          font = {
            family = "Sarasa Term K";
            size = 14;
          };
          
          # Font styles
          fontStyles = {
            regular = "Regular";
            bold = "Bold";
            italic = "Regular Italic";
            boldItalic = "Bold Italic";
          };
          
          # Other common settings
          colors = {
            foreground = "d0d0d0";
            background = "000000";
          };
          
          window = {
            transparency = 0.1;
            blur = true;
          };
        };
      };
    };
  };
}