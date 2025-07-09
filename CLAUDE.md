### Dev Convention
Always include newline at the EOF.

### How to Run Darwin Rebuild
```shell

# Build configuration and switch
darwin-switch

# Check configuration without applying (dry-run)
darwin-check

# Convenient aliases (defined in nix-darwin/modules/zsh/default.nix)
# darwin-rebuild - Apply configuration with switch
# darwin-rebuild-check - Check configuration without applying
```

### Configuration Structure
The main darwin configuration is located in `./modules/darwin` directory.
No longer using `configuration.nix` - the flake imports `./modules/darwin` directly.
