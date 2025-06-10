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
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review and customize /etc/nix-darwin/flake.nix"
echo "2. Review and customize /etc/nix-darwin/configuration.nix"
echo "3. Run: sudo nix run nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch"
echo "4. After first install, use: sudo darwin-rebuild switch"

echo -e "${GREEN}Contents of flake.nix:${NC}"
cat flake.nix

if [ -f "configuration.nix" ]; then
    echo -e "${GREEN}Contents of configuration.nix:${NC}"
    cat configuration.nix
fi
