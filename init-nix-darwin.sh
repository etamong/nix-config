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

# Copy our centralized configuration and customize it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="${SCRIPT_DIR}/.config/nix-darwin/configuration.nix"

if [ -f "$CONFIG_SOURCE" ]; then
    echo -e "${YELLOW}Using centralized configuration from repository...${NC}"
    
    # Copy and customize the configuration
    cp "$CONFIG_SOURCE" configuration.nix
    
    # Replace placeholders with actual values
    sed -i '' "s/__USERNAME__/${CURRENT_USER}/g" configuration.nix
    
    echo -e "${GREEN}Applied configuration.nix with:${NC}"
    echo "- Username: ${CURRENT_USER}"
    echo "- Homebrew integration with iTerm2, Chrome, Karabiner"
    echo "- macOS system defaults (Dock, Finder, Keyboard)"
    echo "- Touch ID for sudo authentication"
    
elif [ -f "configuration.nix" ]; then
    echo -e "${YELLOW}Using default generated configuration.nix...${NC}"
    # Update username in default configuration
    sed -i '' "s/users.users.simple/users.users.${CURRENT_USER}/" configuration.nix
    sed -i '' "s/home = \"\/Users\/simple\"/home = \"\/Users\/${CURRENT_USER}\"/" configuration.nix
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
