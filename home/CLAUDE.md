# Claude Code Configuration

## Project Context
My Nix configuration and home-manager configuration are managed in `~/sources/github.com/jholee/nix-config`.

## Configuration Management

### Location
- **Main config repo**: `~/sources/github.com/jholee/nix-config`
- **Nix-darwin config**: `~/sources/github.com/jholee/nix-config/.config/nix-darwin/configuration.nix`
- **Home-manager config**: `~/sources/github.com/jholee/nix-config/.config/home-manager/home.nix`

### Workflow for Configuration Changes

1. **Navigate to config directory**:
   ```bash
   cd ~/sources/github.com/jholee/nix-config
   ```

2. **Check current status**:
   ```bash
   git status
   git diff
   ```

3. **Edit configuration files** as needed

4. **Apply nix-darwin changes**:
   ```bash
   ./update-nix-darwin.sh
   ```

5. **Apply home-manager changes**:
   ```bash
   home-manager switch
   ```

6. **Commit changes**:
   ```bash
   git add .
   git commit -m "feat: [description of changes]"
   ```

## Key Scripts
- `update-nix-darwin.sh` - Apply nix-darwin configuration changes
- `init-nix-darwin.sh` - Initial nix-darwin setup
- `link.sh` - Link configuration files

## Configuration Guidelines
- System-level packages: `environment.systemPackages` in nix-darwin
- GUI applications: `homebrew.casks` in nix-darwin
- User-level packages: `home.packages` in home-manager
- Use `__USERNAME__` placeholder for username references
- Always test changes before committing