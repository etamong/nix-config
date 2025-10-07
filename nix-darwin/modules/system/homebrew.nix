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
      "ktr0731/evans" # for evans gRPC client
    ];

    brews = [
      "imagemagick" # image converter
      "doxx" # terminal document viewer for Microsoft Word files
      "evans" # gRPC client
      "grpcurl"
      "teleport" # Teleport client (tsh)
    ];

    casks = [
      "iterm2"
      "gitkraken"
      "google-chrome"
      "karabiner-elements"
      "claude"
      "ghostty"
      "1password"
      # Add GUI applications here
    ];
  };
}
