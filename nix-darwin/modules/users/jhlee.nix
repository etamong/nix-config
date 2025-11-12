# User-specific configuration for jhlee
{ config, lib, pkgs, ... }:

{
  # Enable program modules
  programs.zsh.enablePowerlevel10k = true;
  programs.dev-tools.enable = true;
  programs.git.enhancedConfig = true;

  # Enable services
  services.awsctx.enable = true;

  # User-specific theme selection
  themes.selected = "nord";

  # NixVim configuration
  programs.nixvim = {
    enable = true;

    # Disable all default plugins
    enableMan = false;

    # Color scheme
    colorschemes.nord.enable = true;

    # Basic options
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;

      # Search settings
      hlsearch = true;
      incsearch = true;
      ignorecase = true;
      smartcase = true;

      # Enable mouse support
      mouse = "a";

      # Clipboard
      clipboard = "unnamedplus";
    };

    # Plugins
    plugins = {
      # Essential plugins
      vim-surround.enable = true;
      commentary.enable = true;
      fugitive.enable = true;

      # Language support
      nix.enable = true;

      # File navigation
      fzf-lua.enable = true;

      # Status line
      lualine.enable = true;

      # Git integration
      gitsigns.enable = true;
    };

    # Extra plugins not available as nixvim plugins
    extraPlugins = with pkgs.vimPlugins; [
      vim-easy-align
      vim-go
      vim-terraform
    ];

    # Extra configuration
    extraConfigVim = ''
      " Enable syntax highlighting
      syntax on
      filetype plugin indent on
    '';
  };
}