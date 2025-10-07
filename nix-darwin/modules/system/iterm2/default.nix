{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.iterm2;
in
{
  options.programs.iterm2 = {
    enhancedConfig = mkEnableOption "Enhanced iTerm2 configuration";

    # General preferences
    disablePromptOnQuit = mkOption {
      type = types.bool;
      default = true;
      description = "Disable the confirmation prompt when quitting iTerm2";
    };

    # Appearance preferences
    theme = mkOption {
      type = types.enum [ "light" "dark" "auto" ];
      default = "dark";
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

    # Smart features
    enableSmartSelection = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable smart selection";
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

          unlimitedScrollback = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to allow unlimited scrollback";
          };

          scrollbackLines = mkOption {
            type = types.int;
            default = 100000;
            description = "Number of lines to keep in scrollback buffer";
          };

          workingDirectory = mkOption {
            type = types.str;
            default = "~/";
            description = "Initial working directory";
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
            default = 2;
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

    # Status bar configuration
    statusBar = mkOption {
      type = types.submodule {
        options = {
          show = mkOption {
            type = types.bool;
            default = true;
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
            default = [ "CurrentDirectory" "CPU" "Memory" "Battery" "DateTime" ];
            description = "Components to show in the status bar";
          };
        };
      };
      default = { };
      description = "Status bar configuration";
    };
  };

  config = mkIf cfg.enhancedConfig {
    # Configuration activation script
    system.activationScripts.iterm2-config.text = ''
      echo "Configuring iTerm2..."
      
      # Check if the Launch Services registration needs to be fixed
      ITERM_PATH="${pkgs.iterm2}/Applications/iTerm2.app"
      if [ -e "$ITERM_PATH" ]; then
        echo "Re-registering iTerm2 with Launch Services"
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$ITERM_PATH" > /dev/null 2>&1
      fi

      # Set basic preferences using defaults
      /usr/bin/defaults write com.googlecode.iterm2 "QuitWhenAllWindowsClosed" -bool false
      /usr/bin/defaults write com.googlecode.iterm2 "PromptOnQuit" -bool ${if cfg.disablePromptOnQuit then "false" else "true"}
      /usr/bin/defaults write com.googlecode.iterm2 "UseMetal" -bool true
      /usr/bin/defaults write com.googlecode.iterm2 "AlternateMouseScroll" -bool true
      /usr/bin/defaults write com.googlecode.iterm2 "SoundForEsc" -bool false

      # Tab styling
      /usr/bin/defaults write com.googlecode.iterm2 "TabStyleWithAutomaticOption" -int 5
      /usr/bin/defaults write com.googlecode.iterm2 "TabViewType" -int 0
      /usr/bin/defaults write com.googlecode.iterm2 "HideTab" -bool false
      /usr/bin/defaults write com.googlecode.iterm2 "ShowPaneTitles" -bool true
      /usr/bin/defaults write com.googlecode.iterm2 "ShowFullScreenTabBar" -bool true
      /usr/bin/defaults write com.googlecode.iterm2 "StretchTabsToFillBar" -bool true

      ${optionalString cfg.useDefaultProfile ''
      # Create default profile
      /usr/bin/defaults write com.googlecode.iterm2 "New Bookmarks" -array
      /usr/bin/defaults write com.googlecode.iterm2 "New Bookmarks" -array-add '{
          "Name" = "Default";
          "Guid" = "Default";
          "Default Bookmark" = "Yes";
          "Normal Font" = "${cfg.profiles.Default.font or "MesloLGS-NF-Regular"} ${toString (cfg.profiles.Default.fontSize or 13)}";
          "ASCII Anti Aliased" = 1;
          "Columns" = 120;
          "Rows" = 30;
          "Working Directory" = "${cfg.profiles.Default.workingDirectory or "~/"}";
          "Blur" = ${if (cfg.profiles.Default.blurBackground or true) then "1" else "0"};
          "Blur Radius" = ${toString (cfg.profiles.Default.blurRadius or 2)};
          "Transparency" = ${toString (cfg.profiles.Default.transparency or 0.3)};
          "Only The Default BG Color Uses Transparency" = ${if (cfg.profiles.Default.useTransparencyOnlyForDefaultBg or true) then "1" else "0"};
          "Unlimited Scrollback" = ${if (cfg.profiles.Default.unlimitedScrollback or true) then "1" else "0"};
      }'

      # Set the default bookmark
      /usr/bin/defaults write com.googlecode.iterm2 "Default Bookmark Guid" "Default"
      ''}

      # Force preferences to take effect
      killall cfprefsd 2>/dev/null || true
      
      echo "iTerm2 configuration complete"
    '';
  };
}