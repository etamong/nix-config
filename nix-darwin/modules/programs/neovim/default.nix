{ config, lib, pkgs, ... }:

with lib;

{
  options.programs.neovim.enhancedConfig = mkEnableOption "Enhanced Neovim configuration with plugins and LSP";

  config = mkIf config.programs.neovim.enhancedConfig {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
        # Navigation
        leap-nvim

        # Fuzzy finder
        telescope-nvim
        telescope-fzf-native-nvim
        plenary-nvim

        # Treesitter for better syntax highlighting
        nvim-treesitter.withAllGrammars

        # LSP
        nvim-lspconfig

        # Lazygit integration
        lazygit-nvim

        # Theme
        nord-nvim

        # Additional useful plugins
        vim-commentary
        vim-surround
        nvim-web-devicons
      ];

      extraPackages = with pkgs; [
        # LSP servers
        nixd
        lua-language-server
        nodePackages.typescript-language-server
        rust-analyzer
        gopls
        pyright

        # Additional tools
        ripgrep
        fd
        lazygit
      ];

      extraLuaConfig = ''
        -- Leader key
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '

        -- Basic settings
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.mouse = 'a'
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.hlsearch = true
        vim.opt.wrap = false
        vim.opt.breakindent = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
        vim.opt.signcolumn = 'yes'
        vim.opt.updatetime = 250
        vim.opt.timeoutlen = 300
        vim.opt.splitright = true
        vim.opt.splitbelow = true
        vim.opt.termguicolors = true

        -- Nord theme
        vim.cmd('colorscheme nord')

        -- Leap setup
        require('leap').add_default_mappings()

        -- Telescope setup
        require('telescope').setup({
          defaults = {
            mappings = {
              i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
              },
            },
          },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            }
          }
        })

        -- Load telescope fzf extension
        require('telescope').load_extension('fzf')

        -- Telescope keybindings
        vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find files' })
        vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
        vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find buffers' })
        vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help tags' })
        vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = 'Recent files' })

        -- Treesitter setup
        require('nvim-treesitter.configs').setup({
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = {
            enable = true,
          },
        })

        -- LSP setup
        local lspconfig = require('lspconfig')

        -- Keybindings for LSP
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
        })

        -- Configure LSP servers
        lspconfig.nixd.setup({})
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false },
            },
          },
        })
        lspconfig.tsserver.setup({})
        lspconfig.rust_analyzer.setup({})
        lspconfig.gopls.setup({})
        lspconfig.pyright.setup({})

        -- Lazygit setup
        vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

        -- Additional keybindings
        vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
        vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save' })
        vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })

        -- Better window navigation
        vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
        vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
        vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
        vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })
      '';
    };
  };
}
