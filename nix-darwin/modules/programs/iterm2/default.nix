{ config, lib, pkgs, ... }:

{
  # iTerm2 setup with home-manager
  home.packages = with pkgs; [
    iterm2
  ];

  home.activation = {
    setup-iterm2 = lib.hm.dag.entryAfter ["linkGeneration"] ''
      echo "Setting up iTerm2 for Spotlight indexing..."
      
      # Find iTerm2 in nix store and create link in Applications
      ITERM_STORE_PATH=$(find /nix/store -name "iTerm2.app" -type d 2>/dev/null | head -1)
      APPS_DIR="$HOME/Applications"
      
      if [ -n "$ITERM_STORE_PATH" ]; then
        echo "Found iTerm2 at: $ITERM_STORE_PATH"
        mkdir -p "$APPS_DIR"
        rm -f "$APPS_DIR/iTerm2.app"
        ln -sf "$ITERM_STORE_PATH" "$APPS_DIR/iTerm2.app"
        echo "Created link: $APPS_DIR/iTerm2.app"
        
        # Register with Launch Services for Spotlight
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APPS_DIR/iTerm2.app" >/dev/null 2>&1 || true
        /usr/bin/mdimport "$APPS_DIR/iTerm2.app" >/dev/null 2>&1 || true
        echo "iTerm2 registered with Spotlight"
      else
        echo "iTerm2 not found in nix store"
      fi
    '';
  };
}