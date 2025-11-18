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

    # Extra packages (LSP servers, formatters, etc.)
    extraPackages = with pkgs; [
      # LSP servers
      nixd
      gopls
      pyright
      rust-analyzer
      lua-language-server
      nodePackages.typescript-language-server

      # Additional tools
      ripgrep
      fd
      lazygit
    ];

    # Leader key
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

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
      fzf-lua = {
        enable = true;
        keymaps = {
          "<leader>ff" = "files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fr" = "oldfiles";
          "<leader>fc" = "grep_cword";
          "<C-p>" = "files";
        };
      };

      # Status line
      lualine.enable = true;

      # Git integration
      gitsigns.enable = true;

      lazygit = {
        enable = true;
        settings = {
          floating_window_use_plenary = 0;
          floating_window_scaling_factor = 0.9;
          floating_window_border_chars = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
        };
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          gopls.enable = true;
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          lua_ls.enable = true;
          ts_ls.enable = true;
        };
        keymaps = {
          diagnostic = {
            "<leader>e" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>q" = "setloclist";
          };
          lspBuf = {
            "gD" = "declaration";
            "gd" = "definition";
            "K" = "hover";
            "gi" = "implementation";
            "<C-k>" = "signature_help";
            "<leader>wa" = "add_workspace_folder";
            "<leader>wr" = "remove_workspace_folder";
            "<leader>D" = "type_definition";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            "gr" = "references";
            "<leader>f" = "format";
          };
        };
      };

      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

      # Treesitter for better syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
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

    # Keymaps
    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "Open LazyGit";
          silent = true;
        };
      }
    ];
  };
}