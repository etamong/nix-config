{ config, pkgs, ... }: {
  # Homebrew integration
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      # These taps are now included by default
    ];

    brews = [
      "imagemagick" # image converter
    ];

    casks = [
      "iterm2"
      "gitkraken"
      "google-chrome"
      "karabiner-elements"
      "claude"
      "ghostty"
      # Add GUI applications here
    ];
  };
}
