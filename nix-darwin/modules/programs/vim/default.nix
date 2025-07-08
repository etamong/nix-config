# Vim configuration module
{ config, lib, pkgs, vim-nord, vim-surround, vim-commentary, vim-easy-align, fzf-vim, vim-fugitive, vim-nix, vim-terraform, vim-go, ... }:

with lib;

{
  options.programs.vim.enable = mkEnableOption "Vim configuration";

  config = mkIf config.programs.vim.enable {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        # Theme
        (pkgs.vimUtils.buildVimPlugin {
          name = "nord-vim";
          src = vim-nord;
        })
        
        # Essential plugins
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-surround";
          src = vim-surround;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-commentary";
          src = vim-commentary;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-easy-align";
          src = vim-easy-align;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "fzf-vim";
          src = fzf-vim;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-fugitive";
          src = vim-fugitive;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-nix";
          src = vim-nix;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-terraform";
          src = vim-terraform;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-go";
          src = vim-go;
        })
      ];
      
      extraConfig = ''
        " Nord theme
        colorscheme nord
        
        " Basic settings
        set number
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set autoindent
        set smartindent
        
        " Search settings
        set hlsearch
        set incsearch
        set ignorecase
        set smartcase
        
        " Enable syntax highlighting
        syntax on
        filetype plugin indent on
      '';
    };
  };
}