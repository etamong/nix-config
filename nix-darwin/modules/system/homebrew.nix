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
      "wireguard-tools" # WireGuard VPN CLI tools
      "wireguard-go" # WireGuard userspace implementation
    ];

    casks = [
      "google-chrome"
      "karabiner-elements"
      "claude"
      "ghostty"
      "1password"
      "raycast"
      # Add GUI applications here
    ];
  };
}
