# Claude Code Configuration

## Project Context
This is a nix configuration repository managing both home-manager (user-level) and nix-darwin (system-level) configurations for macOS.

## nix-darwin Configuration Workflow

When working with nix-darwin configuration:

1. **Before making changes**: Always check for unapplied changes first
   ```bash
   git status
   git diff
   ```
   If there are uncommitted changes, review them with the user before proceeding.

2. **Edit configuration**: Make changes to `.config/nix-darwin/configuration.nix`

3. **Apply changes**: Run the update script to copy to system location and rebuild
   ```bash
   ./update-nix-darwin.sh
   ```

4. **Commit changes**: Create descriptive commit with the changes made
   ```bash
   git add .
   git commit -m "feat: [description of nix-darwin changes]"
   ```

## Key Files
- `.config/nix-darwin/configuration.nix` - Centralized nix-darwin configuration (edit this)
- `update-nix-darwin.sh` - Script to apply configuration changes
- `init-nix-darwin.sh` - Initial nix-darwin setup script
- `.config/home-manager/home.nix` - Home-manager configuration

## Configuration Guidelines
- Use `__USERNAME__` placeholder for username references in nix-darwin config
- System-level packages go in `environment.systemPackages`
- GUI applications go in `homebrew.casks`
- CLI tools can go in either `homebrew.brews` or home-manager packages
- Always test configuration changes before committing

## Common Tasks
- **Add GUI app**: Add to `homebrew.casks` in nix-darwin config
- **Add CLI tool**: Add to `home.packages` in home-manager config
- **Change system settings**: Modify `system.defaults` in nix-darwin config
- **Update Homebrew apps**: Modify `homebrew` section in nix-darwin config