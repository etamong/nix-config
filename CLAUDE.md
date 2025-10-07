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

### Module Development Guidelines

#### Git Tracking Requirement
**CRITICAL**: Nix modules must be committed to git before they can be properly referenced.

```shell
# ❌ This will fail - module not in git
nix build --dry-run .#darwinConfigurations.$(hostname).system
# Error: path '/nix/store/.../modules/new-module' does not exist

# ✅ Correct workflow
git add modules/new-module/
git commit -m "feat: Add new module"
nix build --dry-run .#darwinConfigurations.$(hostname).system  # Now works
```

#### Module Development Workflow
1. **Create module** in appropriate directory (`./modules/`)
2. **Add to imports** in relevant configuration files
3. **Commit to git** immediately - this is essential for nix to find the module
4. **Test configuration** with `darwin-check` or `nix build --dry-run`
5. **Apply changes** with `darwin-switch`

#### Common Module Locations
- **System modules**: `./modules/system/` (darwin-level configuration)
- **User modules**: `./modules/home/` (home-manager configuration)  
- **Program modules**: `./modules/programs/` (application-specific settings)
- **Theme modules**: `./modules/themes/` (UI/appearance configuration)
