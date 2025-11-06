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
    saml2aws
    tfswitch
    vault

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

    # Basic neovim configuration
    ".config/nvim/init.lua".text = ''
      -- Basic neovim configuration
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.autoindent = true
      vim.opt.smartindent = true
      
      -- Search settings
      vim.opt.hlsearch = true
      vim.opt.incsearch = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      
      -- Enable syntax highlighting
      vim.cmd("syntax on")
      vim.cmd("filetype plugin indent on")
    '';
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
