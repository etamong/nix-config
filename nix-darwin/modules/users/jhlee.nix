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
      terraform-ls

      # Additional tools
      ripgrep
      fd
      lazygit
      tree-sitter

      # Image preview tools for fzf-lua
      viu
      chafa
      ueberzugpp
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

      # File settings
      fixeol = true;  # Ensure newline at end of file
      endofline = true;  # Write EOL for last line
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
        settings = {
          files = {
            previewer = "builtin";
          };
          grep = {
            previewer = "builtin";
          };
        };
      };

      web-devicons.enable = true;

      nvim-tree = {
        enable = true;
        openOnSetup = false;
        settings = {
          sort_by = "case_sensitive";
          view = {
            width = 30;
            side = "left";
          };
          renderer = {
            group_empty = true;
            icons.glyphs = {
              default = "";
              symlink = "";
              folder = {
                arrow_closed = "";
                arrow_open = "";
                default = "";
                open = "";
                empty = "";
                empty_open = "";
                symlink = "";
                symlink_open = "";
              };
              git = {
                unstaged = "✗";
                staged = "✓";
                unmerged = "";
                renamed = "➜";
                untracked = "★";
                deleted = "";
                ignored = "◌";
              };
            };
          };
          filters = {
            dotfiles = false;
          };
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
          terraformls.enable = true;
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

      # GitHub Copilot
      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = false;  # Disabled as recommended when using copilot-cmp
            auto_trigger = true;
            keymap = {
              accept = "<M-l>";
              accept_word = false;
              accept_line = false;
              next = "<M-]>";
              prev = "<M-[>";
              dismiss = "<C-]>";
            };
          };
          panel = {
            enabled = false;  # Disabled as recommended when using copilot-cmp
            auto_refresh = false;
            keymap = {
              jump_prev = "[[";
              jump_next = "]]";
              accept = "<CR>";
              refresh = "gr";
              open = "<M-CR>";
            };
          };
        };
      };

      copilot-cmp = {
        enable = true;
      };

      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "copilot"; }
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

    extraConfigLua = ''
      -- Configure fzf-lua image preview
      require('fzf-lua').setup({
        previewers = {
          builtin = {
            ueberzug_scaler = "cover",
            extensions = {
              ["png"] = { "viu", "-b" },
              ["jpg"] = { "viu", "-b" },
              ["jpeg"] = { "viu", "-b" },
              ["gif"] = { "viu", "-b" },
              ["webp"] = { "viu", "-b" },
            },
          },
        },
      })
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
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<CR>";
        options = {
          desc = "Toggle file tree";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>NvimTreeFocus<CR>";
        options = {
          desc = "Focus file tree";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>i";
        action = "<cmd>NvimTreeFindFile<CR>";
        options = {
          desc = "Find current file in tree";
          silent = true;
        };
      }
    ];
  };
}
