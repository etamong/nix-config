### Dev Convention
Always include newline at the EOF.

### How to Run Darwin Rebuild
```shell
darwin-rebuild switch --flake $PATH_TO_CURRENT_DIRECTORY/nix-darwin#$(hostname)
```

### Configuration Structure
The main darwin configuration is located in `./modules/darwin` directory.
No longer using `configuration.nix` - the flake imports `./modules/darwin` directly.
