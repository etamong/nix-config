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
            <key>Foreground Color</key>
            <dict>
              <key>Red Component</key>
              <real>0.8156862745098039</real>
              <key>Green Component</key>
              <real>0.8156862745098039</real>
              <key>Blue Component</key>
              <real>0.8156862745098039</real>
            </dict>
            <key>Background Color</key>
            <dict>
              <key>Red Component</key>
              <real>0.0</real>
              <key>Green Component</key>
              <real>0.0</real>
              <key>Blue Component</key>
              <real>0.0</real>
            </dict>
            <key>Transparency</key>
            <real>0.1</real>
            <key>Blur</key>
            <true/>
            <key>Disable Window Resizing</key>
            <false/>
            <key>Sync Title</key>
            <true/>
            <key>Close Sessions On End</key>
            <true/>
            <key>Flashing Bell</key>
            <false/>
            <key>Visual Bell</key>
            <false/>
            <key>Use Custom Window Title</key>
            <false/>
            <key>Use Transparency</key>
            <true/>
            <key>Minimum Contrast</key>
            <real>0</real>
            <key>Use Bold Font</key>
            <true/>
            <key>Use Bright Bold</key>
            <true/>
            <key>BM Growl</key>
            <true/>
            <key>Send Code When Idle</key>
            <false/>
            <key>ASCII Anti Aliased</key>
            <true/>
            <key>Non Ascii Font</key>
            <string>SarasaTermK-Regular 14</string>
            <key>Vertical Spacing</key>
            <real>1</real>
            <key>Horizontal Spacing</key>
            <real>1</real>
            <key>Right Option Key Sends</key>
            <integer>0</integer>
            <key>Left Option Key Sends</key>
            <integer>0</integer>
            <key>Terminal Type</key>
            <string>xterm-256color</string>
            <key>Scrollback Lines</key>
            <integer>10000</integer>
            <key>Mouse Reporting</key>
            <true/>
            <key>Disable Smcup Rmcup</key>
            <false/>
            <key>Silence Bell</key>
            <true/>
            <key>Unicode Normalization</key>
            <integer>0</integer>
            <key>Character Encoding</key>
            <integer>4</integer>
            <key>Ambiguous Double Width</key>
            <false/>
            <key>Unlimited Scrollback</key>
            <false/>
            <key>Keyboard Map</key>
            <dict>
              <key>0xf700-0x260000</key>
              <dict>
                <key>Action</key>
                <integer>10</integer>
                <key>Text</key>
                <string>[1;6A</string>
              </dict>
              <key>0xf701-0x260000</key>
              <dict>
                <key>Action</key>
                <integer>10</integer>
                <key>Text</key>
                <string>[1;6B</string>
              </dict>
              <key>0xf702-0x260000</key>
              <dict>
                <key>Action</key>
                <integer>10</integer>
                <key>Text</key>
                <string>[1;6D</string>
              </dict>
              <key>0xf703-0x260000</key>
              <dict>
                <key>Action</key>
                <integer>10</integer>
                <key>Text</key>
                <string>[1;6C</string>
              </dict>
            </dict>
          </dict>
        </array>
      </dict>
      </plist>
    '';
  };
}