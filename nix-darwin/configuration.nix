{ config, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Essential tools
    vim
    #neovim
    git
    curl
    wget
    htop
    btop
    tree
    jq
    yq

    # DevOps/SRE/Cloud Engineering tools
    kubectl
    kubectx
    k9s
#    helm
    terraform
    terragrunt
    ansible
    docker
    docker-compose
    awscli2
    azure-cli
    google-cloud-sdk


    # Monitoring and observability
    prometheus
    grafana

    # Python and development
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nodejs

    # Network tools
    nmap
    dig
    tcpdump

    # Other useful tools
    tmux
    screen
    rsync
    unzip
    zip
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

  services.nix-daemon.enable = true;

  # Set the path to the darwin configuration
  environment.darwinConfig = "/Users/jhlee/sources/github.com/jholee/nix-config/etc/nix-darwin/configuration.nix";

#  # Enable sudo authentication with Touch ID
#  security.pam.services.sudo_local.touchIdAuth = true;

  # Nix package manager settings
  nix = {
    package = pkgs.nix;

    # Necessary for using flakes on this system.
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "@admin" "jhlee" ];
    };

    gc = {
        automatic = true;
        interval = { Weekday = 0; Hour = 2; Minute = 0; };
        options = "--delete-older than 30d";
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

  system.defaults = {
    # dock
    dock = {
        autohide = true;
        mru-spaces = false;
    };

    # finder
    finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
    };

#    # NSGlobalDomain
#    NSGlobalDomain = {
#        AppleShowAllExtensions = true;
#        InitialKeyRepeat = 14;
#        KeyRepeat = 1;
#    }
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}
