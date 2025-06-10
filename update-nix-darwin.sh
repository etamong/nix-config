#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get current system configuration
CURRENT_USER=$(whoami)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="${SCRIPT_DIR}/.config/nix-darwin/configuration.nix"

echo -e "${YELLOW}Updating nix-darwin configuration...${NC}"

if [ ! -f "$CONFIG_SOURCE" ]; then
    echo "Error: Configuration file not found at $CONFIG_SOURCE"
    exit 1
fi

if [ ! -d "/etc/nix-darwin" ]; then
    echo "Error: nix-darwin not installed. Run ./init-nix-darwin.sh first."
    exit 1
fi

# Copy and customize the configuration
sudo cp "$CONFIG_SOURCE" /etc/nix-darwin/configuration.nix

# Replace placeholders with actual values
sudo sed -i '' "s/__USERNAME__/${CURRENT_USER}/g" /etc/nix-darwin/configuration.nix

echo -e "${GREEN}Configuration updated. Applying changes...${NC}"

# Apply the configuration
darwin-rebuild switch

echo -e "${GREEN}✅ nix-darwin configuration updated successfully!${NC}"
