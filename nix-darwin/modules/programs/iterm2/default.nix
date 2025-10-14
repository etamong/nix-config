# modules/programs/iterm2/default.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.iterm2;

  # Convert font name to PostScript format
  # e.g., "Sarasa Term K" -> "Sarasa-Term-K-Regular"
  #       "MesloLGS NF" -> "MesloLGS-NF-Regular"
  fontToPostScript = fontName:
    let
      # Remove spaces and replace with hyphens for PostScript format
      baseName = builtins.replaceStrings [" "] ["-"] fontName;
    in
      "${baseName}-Regular";
in
{
  imports = [
    ./configuration.nix
  ];

  options.programs.iterm2 = {
    enable = mkEnableOption "iTerm2 configuration";

    # General preferences
    disablePromptOnQuit = mkOption {
      type = types.bool;
      default = true;
      description = "Disable the confirmation prompt when quitting iTerm2";
    };

    # Appearance preferences
    theme = mkOption {
      type = types.enum [ "light" "dark" "auto" ];
      default = "auto";
      description = "Theme setting for iTerm2";
    };

    tabsPosition = mkOption {
      type = types.enum [ "top" "bottom" ];
      default = "top";
      description = "Position of tabs in iTerm2";
    };

    # Window preferences
    windowStyle = mkOption {
      type = types.enum [ "normal" "fullscreen" "maximized" ];
      default = "normal";
      description = "Default window style";
    };

    # Advanced preferences
    advancedPreferences = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Advanced preferences for iTerm2 using raw key-value pairs";
      example = literalExpression ''{ 
        "AlternateMouseScroll" = true;
        "AutoHideTmuxClientSession" = false;
        "SoundForEsc" = false;
        "FindMode_EntireWord" = true;
      }'';
    };

    # Status bar configuration
    statusBar = {
      show = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to show the status bar";
      };

      position = mkOption {
        type = types.enum [ "top" "bottom" ];
        default = "bottom";
        description = "Position of the status bar";
      };

      components = mkOption {
        type = types.listOf (types.enum [
          "CPU"
          "Memory"
          "Network"
          "CurrentDirectory"
          "UserName"
          "HostName"
          "DateTime"
          "Battery"
        ]);
        default = [ "CurrentDirectory" "DateTime" ];
        description = "Components to show in the status bar";
      };
    };

    # Profile settings
    profiles = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          default = mkOption {
            type = types.bool;
            default = false;
            description = "Whether this is the default profile";
          };

          name = mkOption {
            type = types.str;
            description = "Profile name";
          };

          font = mkOption {
            type = types.str;
            default = "MesloLGS-NF-Regular";
            description = "Font to use for the profile";
          };

          fontSize = mkOption {
            type = types.int;
            default = 13;
            description = "Font size to use for the profile";
          };

          useNonAsciiFont = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to use a different font for non-ASCII characters";
          };

          nonAsciiFont = mkOption {
            type = types.str;
            default = "NanumGothicCoding";
            description = "Font to use for non-ASCII characters";
          };

          nonAsciiFontSize = mkOption {
            type = types.int;
            default = 13;
            description = "Font size to use for non-ASCII characters";
          };

          cursorType = mkOption {
            type = types.enum [ "box" "vertical" "underline" ];
            default = "box";
            description = "Type of cursor to use in the terminal";
          };

          colorScheme = mkOption {
            type = types.enum [ "Default" "Solarized Dark" "Solarized Light" "Nord" "Dracula" "Custom" ];
            default = "Default";
            description = "Color scheme to use for the profile";
          };

          customColors = mkOption {
            type = types.attrsOf types.str;
            default = { };
            description = "Custom colors for the terminal";
          };

          useBoldFont = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to use bold fonts";
          };

          useItalicFont = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to use italic fonts";
          };

          useLigatures = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable font ligatures";
          };

          unlimitedScrollback = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to allow unlimited scrollback";
          };

          scrollbackLines = mkOption {
            type = types.int;
            default = 4000;
            description = "Number of lines to keep in scrollback buffer";
          };

          shell = mkOption {
            type = types.str;
            default = "";
            description = "Shell to use for the profile (leave empty for default shell)";
          };

          workingDirectory = mkOption {
            type = types.str;
            default = "~/";
            description = "Initial working directory (leave empty for home directory)";
          };

          closeOnExit = mkOption {
            type = types.enum [ "always" "clean" "never" ];
            default = "always";
            description = "When to close the terminal after the process exits";
          };

          blurBackground = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to blur the terminal background";
          };

          blurRadius = mkOption {
            type = types.int;
            default = 7;
            description = "Blur radius for the terminal background";
          };

          transparency = mkOption {
            type = types.float;
            default = 0.3;
            description = "Transparency level for the terminal background (0.0-1.0)";
          };

          useTransparencyOnlyForDefaultBg = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to use transparency only for the default background color";
          };
        };
      });
      default = { };
      description = "iTerm2 profiles configuration";
    };

    # Import existing profiles
    useDefaultProfile = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include a default profile";
    };

    # Smart features
    enableSmartSelection = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable smart selection";
    };
  };

  config = mkIf cfg.enable {
    # Ensure iTerm2 is installed
    home.packages = [ pkgs.iterm2 ];

    # Spotlight registration and application setup
    home.activation.setup-iterm2 = lib.hm.dag.entryAfter ["linkGeneration"] ''
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

    # iTerm2 configuration generation
    home.activation.iterm2-config = lib.hm.dag.entryAfter ["setup-iterm2"] ''
      echo "Configuring iTerm2 with Nix settings..."
      
      # Set basic preferences based on Nix options
      /usr/bin/defaults write com.googlecode.iterm2 "PromptOnQuit" -bool ${lib.boolToString (!cfg.disablePromptOnQuit)} > /dev/null 2>&1
      /usr/bin/defaults write com.googlecode.iterm2 "QuitWhenAllWindowsClosed" -bool false > /dev/null 2>&1
      /usr/bin/defaults write com.googlecode.iterm2 "UseMetal" -bool true > /dev/null 2>&1
      
      # Theme settings
      ${optionalString (cfg.theme == "dark") ''
        /usr/bin/defaults write com.googlecode.iterm2 "TabStyleWithAutomaticOption" -int 5 > /dev/null 2>&1
      ''}
      
      ${optionalString (cfg.theme == "auto") ''
        /usr/bin/defaults write com.googlecode.iterm2 "ThemeFollowsSystemAppearance" -bool true > /dev/null 2>&1
      ''}
      
      # Tab position
      /usr/bin/defaults write com.googlecode.iterm2 "TabViewType" -int ${if cfg.tabsPosition == "top" then "0" else "1"} > /dev/null 2>&1
      
      # Advanced preferences
      ${concatStringsSep "\n" (mapAttrsToList (key: value:
        let
          valueStr = if builtins.isBool value then lib.boolToString value
                    else if builtins.isInt value then toString value
                    else if builtins.isFloat value then toString value
                    else if builtins.isString value then value
                    else toString value;
          typeFlag = if builtins.isBool value then "-bool"
                    else if builtins.isInt value then "-int"
                    else if builtins.isFloat value then "-float"
                    else "-string";
        in
          "/usr/bin/defaults write com.googlecode.iterm2 \"${key}\" ${typeFlag} ${valueStr} > /dev/null 2>&1"
      ) cfg.advancedPreferences)}

      # Profile configuration
      ${concatStringsSep "\n" (mapAttrsToList (profileName: profile:
        let
          profileIndex = if profile.default then "0" else "1";
          normalFont = "${fontToPostScript profile.font} ${toString profile.fontSize}";
          nonAsciiFont = if profile.useNonAsciiFont
            then "${fontToPostScript profile.nonAsciiFont} ${toString profile.nonAsciiFontSize}"
            else normalFont;
        in
          ''
            # Configure profile: ${profileName}
            /usr/bin/defaults write com.googlecode.iterm2 "NSNavLastRootDirectory" -string "~/" > /dev/null 2>&1

            # Set font for default profile (index 0)
            /usr/bin/defaults write com.googlecode.iterm2 "New Bookmarks" -array-add '{
              "Name" = "${profile.name}";
              "Guid" = "Default-Profile-${profileName}";
              "Normal Font" = "${normalFont}";
              ${optionalString profile.useNonAsciiFont ''"Non Ascii Font" = "${nonAsciiFont}";''}
              "Use Non-ASCII Font" = ${if profile.useNonAsciiFont then "1" else "0"};
              "ASCII Anti Aliased" = 1;
              "Non-ASCII Anti Aliased" = 1;
              "Use Bold Font" = ${if profile.useBoldFont then "1" else "0"};
              "Use Italic Font" = ${if profile.useItalicFont then "1" else "0"};
              "Use Bright Bold" = 1;
              "Unlimited Scrollback" = ${if profile.unlimitedScrollback then "1" else "0"};
              "Scrollback Lines" = ${toString profile.scrollbackLines};
              "Transparency" = ${toString profile.transparency};
              "Blur" = ${if profile.blurBackground then "1" else "0"};
              "Blur Radius" = ${toString profile.blurRadius};
              "Only The Default BG Color Uses Transparency" = ${if profile.useTransparencyOnlyForDefaultBg then "1" else "0"};
              "Close Sessions On End" = ${if profile.closeOnExit == "always" then "1" else if profile.closeOnExit == "never" then "0" else "2"};
              "Working Directory" = "${profile.workingDirectory}";
              "Custom Directory" = "Yes";
            }' > /dev/null 2>&1 || true

            # Alternative: Modify existing profile directly using PlistBuddy
            ${pkgs.writeShellScript "set-iterm-font" ''
              PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

              # Ensure plist exists
              if [ ! -f "$PLIST" ]; then
                echo "iTerm2 preferences not found. Please run iTerm2 at least once."
                exit 0
              fi

              # Convert binary plist to xml if needed
              plutil -convert xml1 "$PLIST" 2>/dev/null || true

              # Set font in the first profile (index 0)
              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Normal\ Font '${normalFont}'" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Normal\ Font string '${normalFont}'" "$PLIST" 2>/dev/null || true

              ${optionalString profile.useNonAsciiFont ''
                /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Non\ Ascii\ Font '${nonAsciiFont}'" "$PLIST" 2>/dev/null || \
                /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Non\ Ascii\ Font string '${nonAsciiFont}'" "$PLIST" 2>/dev/null || true

                /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Use\ Non-ASCII\ Font true" "$PLIST" 2>/dev/null || \
                /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Use\ Non-ASCII\ Font bool true" "$PLIST" 2>/dev/null || true
              ''}

              # Set other profile options
              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Transparency ${toString profile.transparency}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Transparency real ${toString profile.transparency}" "$PLIST" 2>/dev/null || true

              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Blur ${if profile.blurBackground then "true" else "false"}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Blur bool ${if profile.blurBackground then "true" else "false"}" "$PLIST" 2>/dev/null || true

              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Blur\ Radius ${toString profile.blurRadius}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Blur\ Radius real ${toString profile.blurRadius}" "$PLIST" 2>/dev/null || true

              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Unlimited\ Scrollback ${if profile.unlimitedScrollback then "true" else "false"}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Unlimited\ Scrollback bool ${if profile.unlimitedScrollback then "true" else "false"}" "$PLIST" 2>/dev/null || true

              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Scrollback\ Lines ${toString profile.scrollbackLines}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Scrollback\ Lines integer ${toString profile.scrollbackLines}" "$PLIST" 2>/dev/null || true

              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Use\ Bold\ Font ${if profile.useBoldFont then "true" else "false"}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Use\ Bold\ Font bool ${if profile.useBoldFont then "true" else "false"}" "$PLIST" 2>/dev/null || true

              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Use\ Italic\ Font ${if profile.useItalicFont then "true" else "false"}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Use\ Italic\ Font bool ${if profile.useItalicFont then "true" else "false"}" "$PLIST" 2>/dev/null || true

              /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Only\ The\ Default\ BG\ Color\ Uses\ Transparency ${if profile.useTransparencyOnlyForDefaultBg then "true" else "false"}" "$PLIST" 2>/dev/null || \
              /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0:Only\ The\ Default\ BG\ Color\ Uses\ Transparency bool ${if profile.useTransparencyOnlyForDefaultBg then "true" else "false"}" "$PLIST" 2>/dev/null || true

              echo "iTerm2 profile configured: ${profile.name}"
            ''}
          ''
      ) cfg.profiles)}

      # TODO: 상태바 설정이 안 먹는다. 나중에 함 보자.

      # Status bar configuration
      ${optionalString cfg.statusBar.show ''
        /usr/bin/defaults write com.googlecode.iterm2 "StatusBarEnabled" -bool true > /dev/null 2>&1
        /usr/bin/defaults write com.googlecode.iterm2 "StatusBarPosition" -int ${if cfg.statusBar.position == "bottom" then "1" else "0"} > /dev/null 2>&1
        
        # Status bar components
        /usr/bin/defaults write com.googlecode.iterm2 "StatusBarComponents" -array ${concatMapStringsSep " " (component: 
          let
            componentMap = {
              "CPU" = "com.iterm2.status-bar.cpu";
              "Memory" = "com.iterm2.status-bar.memory";
              "Network" = "com.iterm2.status-bar.network-throughput";
              "CurrentDirectory" = "com.iterm2.status-bar.working-directory";
              "UserName" = "com.iterm2.status-bar.username";
              "HostName" = "com.iterm2.status-bar.hostname";
              "DateTime" = "com.iterm2.status-bar.clock";
              "Battery" = "com.iterm2.status-bar.battery";
            };
          in
            "\"${componentMap.${component} or "com.iterm2.status-bar.${toLower component}"}\""
        ) cfg.statusBar.components} > /dev/null 2>&1
      ''}
      
      # Force preferences to take effect
      killall cfprefsd 2>/dev/null || true
      
      echo "iTerm2 configuration complete"
    '';
  };
}
