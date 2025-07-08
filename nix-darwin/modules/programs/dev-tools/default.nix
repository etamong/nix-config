# Development tools configuration
{ config, lib, pkgs, ... }:

with lib;

{
  options.programs.dev-tools.enable = mkEnableOption "Development tools configuration";

  config = mkIf config.programs.dev-tools.enable {
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
    };
  };
}