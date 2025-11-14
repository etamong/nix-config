{ config, lib, pkgs, ... }: {
  # Base home-manager configuration
  home.username = "jhlee";
  home.homeDirectory = "/Users/jhlee";
  
  # 24.11과 호환되는 버전으로 변경
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Nerd Fonts - Updated syntax
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    
    # Shell tools
    zsh-autosuggestions
    zsh-history-substring-search
    fzf
        
    # Sarasa Gothic font
    sarasa-gothic
    
    # Development tools
    gh
    awscli2
    go
    gotestsum
    nodejs
    python3
    uv
    saml2aws
    tfswitch
    vault
    wireguard-tools
    _1password-cli
    glow

    # GUI Applications
    unstable.claude-code
    jetbrains-toolbox
    jetbrains.rust-rover
  ];

  home.file = {
    ".local/bin/install-claude-code" = {
      text = ''
        #!/bin/sh
        npm install -g @anthropic-ai/claude-code
      '';
      executable = true;
    };

    ".npm-global/.keep".text = "";
  };

  home.sessionVariables = {
    GOPATH = "$HOME/sources/go";
    VAULT_ADDR = "https://vault.devsisters.cloud";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/scripts"
    "$HOME/.cargo/bin"
    "$HOME/sources/go/bin"
    "$HOME/.npm-global/bin"
    "${config.home.homeDirectory}/Library/Application Support/JetBrains/Toolbox/scripts"
  ];

  programs.home-manager.enable = true;
}
