# WireGuard CLI Configuration

This document describes the WireGuard VPN setup on macOS using nix-darwin and Homebrew.

## Overview

WireGuard is configured to automatically start on system boot and provides secure VPN access to infrastructure networks.

## Installation

WireGuard tools are installed through two methods for redundancy:

1. **Nix packages** (declarative) - defined in `modules/system/packages.nix`
2. **Homebrew** (managed by nix-darwin) - defined in `modules/system/homebrew.nix`

Packages installed:
- `wireguard-tools` - Command-line utilities for WireGuard
- `wireguard-go` - Userspace implementation of WireGuard (Homebrew only)

## Configuration

### File Locations

- **Config file**: `/opt/homebrew/etc/wireguard/wg0.conf`
- **LaunchDaemon**: `/Library/LaunchDaemons/com.wireguard.wg0.plist`
- **Logs**: `/tmp/wireguard-wg0.log`

### Configuration Format

The WireGuard configuration file follows this structure:

```conf
[Interface]
PrivateKey = <your-private-key>
Address = <your-ipv4-address>/32
Address = <your-ipv6-address>/128
# DNS = <optional-dns-server>

[Peer]
PublicKey = <peer-public-key>
Endpoint = <peer-endpoint>:<port>
AllowedIPs = <comma-separated-network-cidrs>
```

### Security

- Configuration files are stored with `600` permissions (read/write for root only)
- Private keys are never committed to version control
- The WireGuard config directory has `700` permissions

## Auto-start Configuration

WireGuard is configured to start automatically on boot using macOS launchd.

The launch daemon configuration:
- Automatically starts when network is available
- Keeps the connection alive
- Restarts on failure
- Logs to `/tmp/wireguard-wg0.log`

## Usage

### Basic Commands

```bash
# Check VPN status
sudo wg show

# Show detailed status
sudo wg show wg0

# Manually start VPN
sudo wg-quick up wg0

# Manually stop VPN
sudo wg-quick down wg0
```

### Interface Information

```bash
# Check if interface is up
ifconfig utun4

# Monitor traffic statistics
sudo wg show wg0 transfer

# View current configuration
sudo wg showconf wg0
```

### LaunchDaemon Management

```bash
# Check service status
sudo launchctl print system/com.wireguard.wg0

# Restart service
sudo launchctl kickstart -k system/com.wireguard.wg0

# Stop service (disable auto-start)
sudo launchctl bootout system/com.wireguard.wg0

# Start service (enable auto-start)
sudo launchctl bootstrap system /Library/LaunchDaemons/com.wireguard.wg0.plist
```

### Logs

```bash
# View logs
cat /tmp/wireguard-wg0.log

# Monitor logs in real-time
tail -f /tmp/wireguard-wg0.log
```

## Troubleshooting

### Connection Issues

1. **Check if interface is up**:
   ```bash
   sudo wg show
   ```

2. **Verify endpoint connectivity**:
   ```bash
   ping <endpoint-ip>
   ```

3. **Check logs**:
   ```bash
   cat /tmp/wireguard-wg0.log
   ```

4. **Verify configuration syntax**:
   ```bash
   sudo wg-quick up wg0
   ```

### Common Issues

- **Permission errors**: Ensure config file has `600` permissions
- **Interface not starting**: Check launchd service status
- **No handshake**: Verify endpoint is reachable and ports are open
- **Routing issues**: Check that AllowedIPs doesn't conflict with local networks

## Network Configuration

### Interface Details

- **Interface name**: `utun4` (may vary)
- **Interface type**: WireGuard tunnel
- **MTU**: Default (typically 1420 for WireGuard)

### Routing

WireGuard automatically configures routes for all networks listed in `AllowedIPs`. Traffic to these networks will be routed through the VPN tunnel.

## Applying Configuration Changes

After modifying the nix-darwin configuration:

```bash
cd ~/sources/github.com/etamong/nix-config/nix-darwin
sudo darwin-rebuild switch --flake .#etamong-macbook8
```

If you modify the WireGuard config file directly:

```bash
# Restart the connection to apply changes
sudo wg-quick down wg0
sudo wg-quick up wg0

# Or restart via launchd
sudo launchctl kickstart -k system/com.wireguard.wg0
```

## Security Best Practices

1. Never commit private keys to version control
2. Keep configuration files with restrictive permissions (600)
3. Regularly rotate keys when possible
4. Monitor connection logs for unexpected activity
5. Use DNS over the VPN when connecting to internal resources
6. Verify peer public keys before connecting

## References

- [WireGuard Official Documentation](https://www.wireguard.com/)
- [wg-quick(8) Man Page](https://git.zx2c4.com/wireguard-tools/about/src/man/wg-quick.8)
- [WireGuard Protocol](https://www.wireguard.com/protocol/)
