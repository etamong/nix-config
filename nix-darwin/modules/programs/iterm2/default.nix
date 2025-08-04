{ config, lib, pkgs, ... }:

{
  # iTerm2 configuration for home-manager
  home.file."Library/Preferences/com.googlecode.iterm2.plist" = {
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Default Bookmark Guid</key>
        <string>A8A8A8A8-A8A8-A8A8-A8A8-A8A8A8A8A8A8</string>
        <key>New Bookmarks</key>
        <array>
          <dict>
            <key>Guid</key>
            <string>A8A8A8A8-A8A8-A8A8-A8A8-A8A8A8A8A8A8</string>
            <key>Name</key>
            <string>Default</string>
            <key>Normal Font</key>
            <string>SarasaTermK-Regular 14</string>
            <key>Bold Font</key>
            <string>SarasaTermK-Bold 14</string>
            <key>Italic Font</key>
            <string>SarasaTermK-RegularItalic 14</string>
            <key>Bold Italic Font</key>
            <string>SarasaTermK-BoldItalic 14</string>
            <key>Use Bold Font</key>
            <true/>
            <key>Use Italic Font</key>
            <true/>
            <key>Use Bold Italic Font</key>
            <true/>
          </dict>
        </array>
      </dict>
      </plist>
    '';
  };
}