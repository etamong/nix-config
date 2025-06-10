{ config, lib, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # Add your favorite packages here
  ];

  # Homebrew integration
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    
    taps = [
      "homebrew/cask"
      "homebrew/core"
    ];
    
    brews = [
      # Add CLI tools here
    ];
    
    casks = [
      "iterm2"
      "google-chrome" 
      "karabiner-elements"
      # Add GUI applications here
    ];
  };

  # Fonts
  fonts.packages = [
    # Fonts are managed through home-manager
  ];

  # System settings
  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        minimize-to-application = true;
      };
      
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
      };
    };
    
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  # Users configuration (placeholder for substitution)
  users.users.__USERNAME__ = {
    name = "__USERNAME__";
    home = "/Users/__USERNAME__";
  };

  # Home Manager integration
  imports = [
    <home-manager/nix-darwin>
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.__USERNAME__ = import ./home.nix;
  };

  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  
  # Nix package manager settings
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "@admin" "__USERNAME__" ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = config.rev or config.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}