# ZSH configuration module
{ config, lib, pkgs, zsh-powerlevel10k, ... }:

with lib;

{
  options.programs.zsh.enablePowerlevel10k = mkEnableOption "Powerlevel10k theme for ZSH";

  config = mkIf config.programs.zsh.enablePowerlevel10k {
    programs.zsh = {
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
        if [[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
          source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        fi

        source ${zsh-powerlevel10k}/powerlevel10k.zsh-theme
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

        # Define and execute chawsctx saml infra at the end of shell initialization
        chawsctx() { export AWS_PROFILE=$1; awsctx $2; }
        chawsctx saml infra
      '';
      
      shellAliases = {
        python = "python3";
        vaultctx = "~/.vaultctx/script";
      };
    };
  };
}