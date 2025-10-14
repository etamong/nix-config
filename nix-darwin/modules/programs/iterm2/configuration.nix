# modules/programs/iterm2/configuration.nix
{ config, lib, pkgs, ... }:

{
  # Enable iTerm2 configuration
  programs.iterm2 = {
    enable = true;
    disablePromptOnQuit = true;
    theme = "dark";
    tabsPosition = "top";
    windowStyle = "normal";
    enableSmartSelection = true;

    # Use the default profile
    useDefaultProfile = true;

    # Configure profiles
    # TODO: 뭔가 아직 profile 이 생성은 되는데, 폰트 설정이나 그런게 안 먹는듯..? 다음에 좀 보자. 일부 이모티콘 글자도 깨진다.
    profiles = {
      "Default" = {
        default = true;
        name = "Default";
        # Using MesloLGS NF for better terminal experience
        font = "Sarasa Term K";
        fontSize = 15;
        useNonAsciiFont = false;
        useBoldFont = true;
        useItalicFont = true;
        unlimitedScrollback = true;
        scrollbackLines = 100000; # Still set a high value even though unlimited is enabled
        workingDirectory = "~/";
        blurBackground = true;
        blurRadius = 2;
        transparency = 0.1;
        useTransparencyOnlyForDefaultBg = true;
        closeOnExit = "always";
      };
    };

    # Advanced preferences
    advancedPreferences = {
      "AlternateMouseScroll" = true;
      "FocusFollowsMouse" = false;
      "AutoCommandHistory" = true;
      "SoundForEsc" = false;
      "HideScrollbar" = false;
      "DisableFullscreenTransparency" = false;
      "SplitPaneDimmingAmount" = 0.4;
      "EnableProxyIcon" = true;
      "EnableRendezvous" = false;
      "HideMenuBarInFullscreen" = true;
      "SUEnableAutomaticChecks" = true;
      "DisableWindowSizeSnap" = false;
      "TabStyleWithAutomaticOption" = 5;
      "TabViewType" = 0;
      "HideTab" = false;
      "ShowFullScreenTabBar" = true;
      "ShowPaneTitles" = true;
      "HideTabNumber" = false;
      "HideTabCloseButton" = false;
      "FlashTabBarInFullscreen" = true;
      "StretchTabsToFillBar" = true;
      "WindowStyle" = 0;
      "OpenNewWindowsHere" = true;
      "QuitWhenAllWindowsClosed" = false;
      "PromptOnQuit" = false;
      "ThemeFollowsSystemAppearance" = true;
      "DisableMetalWhenUnplugged" = false;
      "UseMetal" = true;
      "MetalMaximumFramesPerSecond" = 60;
    };

    # Status bar configuration
    statusBar = {
      show = true;
      position = "bottom";
      components = [
        "CurrentDirectory"
        "CPU"
        "Memory"
        "Battery"
        "DateTime"
      ];
    };
  };
}
