{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Nerd Fonts - 24.11 호환 구문
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Meslo" ]; })

    # Shell tools
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-history-substring-search
    fzf

    # Development tools
    gh
    awscli2
    go
    nodejs
    python3
    saml2aws
    vault
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

    # LazyVim configuration
    ".config/nvim/init.lua".text = ''
      -- bootstrap lazy.nvim, LazyVim and your plugins
      require("config.lazy")
    '';

    ".config/nvim/lua/config/lazy.lua".text = ''
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
      end
      vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "plugins" },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        install = { colorscheme = { "tokyonight", "habamax" } },
        checker = { enabled = true },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
          },
        },
      })
    '';

    ".config/nvim/lua/config/autocmds.lua".text = "-- Add any additional autocmds here";
    ".config/nvim/lua/config/keymaps.lua".text = "-- Add any additional keymaps here";
    ".config/nvim/lua/config/options.lua".text = "-- Add any additional options here";
    ".config/nvim/lua/plugins/example.lua".text = "return {}";
  };

  # 복잡한 activation 스크립트 제거하고 단순화
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

    gpg = {
      enable = true;
      settings = {

      };
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    lazygit.enable = true;

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

      initExtra = ''
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

        if [[ -f "$HOME/sources/github.com/devsisters/awsctx/shells/bash/awsctx.sh" ]]; then
          source $HOME/sources/github.com/devsisters/awsctx/shells/bash/awsctx.sh
        fi

        vaultlogin() {
          vault login -method=oidc > /dev/null
        }

        load_vault_envs() {
          export VAULT_ADDR=$(vaultctx get-addr 2>/dev/null || echo "https://vault.devsisters.cloud")
        }

        typeset -a precmd_functions
        precmd_functions+=(load_vault_envs)
      '';

      shellAliases = {
        chawsctx = "foo() { export AWS_PROFILE=$1; awsctx $2}; foo $1 $2";
        python = "python3";
        vaultctx = "~/.vaultctx/script";
      };
    };
  };
  services = {
      gpg-agent = {
          enable = true;
          defaultCacheTtl = 1800;
          enableSshSupport = true;
      };
  };
}
