{ config, lib, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Core Unix utilities (to ensure they're always available)
    coreutils
    findutils
    gnupg
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
      # These taps are now included by default
    ];
    
    brews = [
      # Add CLI tools here
    ];
    
    casks = [
      "iterm2"
      "gitkraken"
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

  # Users configuration 
  users.users.jhlee = {
    name = "jhlee";
    home = "/Users/jhlee";
  };

  # Set primary user for nix-darwin
  system.primaryUser = "jhlee";

  # Set the path to the darwin configuration
  environment.darwinConfig = "/Users/jhlee/sources/github.com/jholee/nix-config/etc/nix-darwin/configuration.nix";

  # Home Manager integration (commented out - manage separately)
  # imports = [
  #   <home-manager/nix-darwin>
  # ];

  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #   users.jhlee = import ../../home/.config/nix/home.nix;
  # };

  # Enable sudo authentication with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  # nix-daemon is now managed automatically by nix-darwin
  
  # Nix package manager settings
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "@admin" "jhlee" ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    # Ensure PATH includes standard system directories
    shellInit = ''
      export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
    '';
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = config.rev or config.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
