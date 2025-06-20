{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jhlee";
  home.homeDirectory = "/Users/jhlee";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.meslo-lg

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.zsh-powerlevel10k
    pkgs.zsh-autosuggestions
    pkgs.zsh-history-substring-search
    pkgs.fzf
    pkgs.claude-code
    pkgs.gh
    pkgs.awscli2
    pkgs.go
    pkgs.nodejs
    pkgs.python3
    pkgs.saml2aws
    pkgs.vault
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    
    ".npm-global/.keep".text = "";
    
    # LazyVim configuration
    ".config/nvim/init.lua".text = ''
      -- bootstrap lazy.nvim, LazyVim and your plugins
      require("config.lazy")
    '';
    
    ".config/nvim/lua/config/lazy.lua".text = ''
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        -- bootstrap lazy.nvim
        -- stylua: ignore
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
      end
      vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

      require("lazy").setup({
        spec = {
          -- add LazyVim and import its plugins
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- import any extras modules here
          -- { import = "lazyvim.plugins.extras.lang.typescript" },
          -- { import = "lazyvim.plugins.extras.lang.json" },
          -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
          -- import/override with your plugins
          { import = "plugins" },
        },
        defaults = {
          -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
          -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
          lazy = false,
          -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
          -- have outdated releases, which may break your Neovim install.
          version = false, -- always use the latest git commit
          -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        install = { colorscheme = { "tokyonight", "habamax" } },
        checker = { enabled = true }, -- automatically check for plugin updates
        performance = {
          rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
              "gzip",
              -- "matchit",
              -- "matchparen",
              -- "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';
    
    ".config/nvim/lua/config/autocmds.lua".text = ''
      -- Autocmds are automatically loaded on the VeryLazy event
      -- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
      -- Add any additional autocmds here
    '';
    
    ".config/nvim/lua/config/keymaps.lua".text = ''
      -- Keymaps are automatically loaded on the VeryLazy event
      -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
      -- Add any additional keymaps here
    '';
    
    ".config/nvim/lua/config/options.lua".text = ''
      -- Options are automatically loaded before lazy.nvim startup
      -- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
      -- Add any additional options here
    '';
    
    ".config/nvim/lua/plugins/example.lua".text = ''
      -- since this is just an example spec, don't actually load anything here and return an empty spec
      -- stylua: ignore
      if true then return {} end

      -- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
      --
      -- In your plugin files, you can:
      -- * add extra plugins
      -- * disable/enabled LazyVim plugins
      -- * override the configuration of LazyVim plugins
      return {
        -- add gruvbox
        { "ellisonleao/gruvbox.nvim" },

        -- Configure LazyVim to load gruvbox
        {
          "LazyVim/LazyVim",
          opts = {
            colorscheme = "gruvbox",
          },
        },
      }
    '';
  };

  # iTerm2 key mappings configuration  
  home.activation.iterm2Config = config.lib.dag.entryAfter ["writeBoundary"] ''
    # Configure iTerm2 key mappings for Option+Arrow word jumping
    # Create the key mappings using defaults command
    /usr/bin/defaults write com.googlecode.iterm2 "GlobalKeyMap" "{\"0xf702-0x300000\":{\"Action\":11,\"Text\":\"0x1b 0x62\"},\"0xf703-0x300000\":{\"Action\":11,\"Text\":\"0x1b 0x66\"}}" 2>/dev/null || echo "iTerm2 key mapping configuration applied"
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jhlee/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    bash.enable = true;
    
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    lazygit = {
      enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      history = {
        path = "$HOME/.zsh_history";
        size = 10000;
        save = 10000;
        share = true;
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
      };
      initContent = ''
        # Ensure PATH is available early for IDE shells
        if [[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
          source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        fi
        
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        autoload -U +X bashcompinit && bashcompinit
        autoload -U +X compinit && compinit

        awslogin() {
          saml2aws login --force --session-duration=43200 --disable-keychain
        }

        source $HOME/sources/github.com/devsisters/awsctx/shells/bash/awsctx.sh

        vaultlogin() {
          vault login -method=oidc > /dev/null
        }

        load_vault_envs() {
          export VAULT_ADDR=$(vaultctx get-addr)
        }
        
        typeset -a precmd_functions
        precmd_functions+=(load_vault_envs)


      '';
      shellAliases = {
        chawsctx = "foo() { export AWS_PROFILE=$1; awsctx $2}; foo $1 $2";
        python = "python3";
        vaultctx = "~/.vaultctx/script";
      };
      loginExtra = ''
        # Only run chawsctx if it's available
        if command -v chawsctx >/dev/null 2>&1; then
          chawsctx saml infra
        fi
      '';
    };
  };


}
