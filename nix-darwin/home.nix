{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  
  home.username = "jhlee";
  home.homeDirectory = "/Users/jhlee";
  
  # 24.11과 호환되는 버전으로 변경
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

		unstable.claude-code
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

    # LazyVim configuration (간단화)
    ".config/nvim/init.lua".text = ''
      -- bootstrap lazy.nvim, LazyVim and your plugins
      require("config.lazy")
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
          if command -v vaultctx >/dev/null 2>&1; then
            export VAULT_ADDR=$(vaultctx get-addr 2>/dev/null || echo "https://vault.devsisters.cloud")
          fi
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
}
