#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get current system configuration
CURRENT_USER=$(whoami)
LOCAL_HOSTNAME=$(scutil --get LocalHostName)
COMPUTER_NAME=$(scutil --get ComputerName)

echo -e "${GREEN}Installing nix-darwin for user: ${CURRENT_USER}${NC}"
echo -e "${GREEN}Local hostname: ${LOCAL_HOSTNAME}${NC}"
echo -e "${GREEN}Computer name: ${COMPUTER_NAME}${NC}"

# Create nix-darwin directory
echo -e "${YELLOW}Creating /etc/nix-darwin directory...${NC}"
sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
cd /etc/nix-darwin

# Initialize flake with nix-darwin template
echo -e "${YELLOW}Initializing nix-darwin flake...${NC}"
nix flake init -t nix-darwin/nix-darwin-24.11

# Update hostname in flake.nix
echo -e "${YELLOW}Updating hostname in flake.nix...${NC}"
sed -i '' "s/simple/${LOCAL_HOSTNAME}/" flake.nix

# Update username in configuration.nix
echo -e "${YELLOW}Updating username in configuration.nix...${NC}"
if [ -f "configuration.nix" ]; then
    sed -i '' "s/users.users.simple/users.users.${CURRENT_USER}/" configuration.nix
    sed -i '' "s/home = \"\/Users\/simple\"/home = \"\/Users\/${CURRENT_USER}\"/" configuration.nix
fi

echo -e "${GREEN}Flake initialized successfully!${NC}"

echo -e "${GREEN}Generated flake.nix:${NC}"
cat flake.nix

if [ -f "configuration.nix" ]; then
    echo -e "${GREEN}Generated configuration.nix:${NC}"
    cat configuration.nix
    
    echo -e "${YELLOW}Customizing configuration.nix for better defaults...${NC}"
    
    # Add Homebrew integration and common settings
    cat > configuration.nix << EOF
{ config, lib, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # \$ nix-env -qaP | grep wget
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

  # Users configuration
  users.users.${CURRENT_USER} = {
    name = "${CURRENT_USER}";
    home = "/Users/${CURRENT_USER}";
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
      trusted-users = [ "@admin" "${CURRENT_USER}" ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = config.rev or config.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # \$ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
EOF

    echo -e "${GREEN}Updated configuration.nix with better defaults:${NC}"
    echo "- Homebrew integration with iTerm2, Chrome, Karabiner"
    echo "- macOS system defaults (Dock, Finder, Keyboard)"
    echo "- Touch ID for sudo authentication"
    echo "- Proper user configuration"
fi

echo -e "${YELLOW}Installing nix-darwin (this may take several minutes)...${NC}"
echo -e "${YELLOW}This will install the system and all Homebrew applications...${NC}"

sudo nix run nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch

echo -e "${GREEN}✅ nix-darwin installation completed successfully!${NC}"
echo -e "${GREEN}✅ Homebrew applications (iTerm2, Chrome, Karabiner) are being installed...${NC}"
echo ""
echo -e "${YELLOW}Future configuration changes can be applied with:${NC}"
echo "  sudo darwin-rebuild switch"
echo ""
echo -e "${YELLOW}To edit your configuration:${NC}"
echo "  sudo vim /etc/nix-darwin/configuration.nix"
echo "  sudo vim /etc/nix-darwin/flake.nix"
