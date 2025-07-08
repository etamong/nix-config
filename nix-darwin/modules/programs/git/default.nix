# Git configuration module
{ config, lib, pkgs, ... }:

with lib;

{
  options.programs.git.enhancedConfig = mkEnableOption "Enhanced Git configuration";

  config = mkIf config.programs.git.enhancedConfig {
    programs.git = {
      enable = true;
      
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        core.editor = "nvim";
        
        # Better diff and merge tools
        diff.tool = "vimdiff";
        merge.tool = "vimdiff";
        
        # Useful aliases
        alias = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          visual = "!gitk";
        };
      };
    };
  };
}