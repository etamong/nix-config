### Dev Convention
Always include newline at the EOF.

### How to Run Darwin Rebuild
```shell
# Build configuration (can run without sudo since jhlee is trusted user)
nix build .#darwinConfigurations.$(hostname).system

# Apply configuration (requires sudo for system activation)
sudo darwin-rebuild switch --flake $PATH_TO_CURRENT_DIRECTORY/nix-darwin#$(hostname)

# Or combine both steps
sudo darwin-rebuild switch --flake .#$(hostname)
```

### Configuration Structure
The main darwin configuration is located in `./modules/darwin` directory.
No longer using `configuration.nix` - the flake imports `./modules/darwin` directly.
