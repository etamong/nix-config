{ config, lib, pkgs, ... }:

{
  # Ghostty terminal configuration
  home.file.".config/ghostty/config" = {
    text = ''
      font-family = "Sarasa Term K"
      font-style = "Regular"
      font-style-bold = "Bold"
      font-style-italic = "Regular Italic"
      font-style-bold-italic = "Bold Italic"
      font-size = 14
      
      # Split behavior
      new-split-inherits-working-directory = false
    '';
  };
}