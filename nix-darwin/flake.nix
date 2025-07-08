{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom saml2aws build from devsisters fork
		saml2aws = {
      url = "github:devsisters/saml2aws";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-powerlevel10k = {
      url = "github:romkatv/powerlevel10k/v1.19.0";
      flake = false;
    };

    ## Vim Plugins
    vim-nord = {
      url = "github:arcticicestudio/nord-vim";
      flake = false;
    };

    vim-surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };

    vim-commentary = {
      url = "github:tpope/vim-commentary";
      flake = false;
    };

    vim-easy-align = {
      url = "github:junegunn/vim-easy-align";
      flake = false;
    };

    fzf-vim = {
      url = "github:junegunn/fzf.vim";
      flake = false;
    };

    vim-fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };

    vim-nix = {
      url = "github:LnL7/vim-nix";
      flake = false;
    };

    vim-terraform = {
      url = "github:hashivim/vim-terraform";
      flake = false;
    };
    
    vim-go = {
      url = "github:fatih/vim-go";
      flake = false;
    };
  };

  outputs = inputs@{ 
    self,
    home-manager,
    nix-darwin,
    nixpkgs,
    nixpkgs-unstable,
    saml2aws,
    zsh-powerlevel10k,
    ## Vim Plugins
    fzf-vim,
    vim-commentary,
    vim-easy-align,
    vim-fugitive,
    vim-go,
    vim-nix,
    vim-nord,
    vim-surround,
    vim-terraform,
  }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.system;
            config.allowUnfree = true;
          };
        })
      ];
    };
  in
  {
    darwinConfigurations = {
      "jhlee-macbook8" = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          configuration
          {
            system.configurationRevision = self.rev or self.dirtyRev or null;
            nixpkgs.hostPlatform = "aarch64-darwin";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = {
              jhlee = import ./home/jhlee.nix;
            };
          }
        ];
      };
      "macbook-jooholee" = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          configuration
          {
            system.configurationRevision = self.rev or self.dirtyRev or null;
            nixpkgs.hostPlatform = "aarch64-darwin";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = {
              jhlee = import ./home/jhlee.nix;
            };
          }
        ];
      };
    };
    darwinPackages = self.darwinConfigurations."jhlee-macbook8".pkgs;
  };
}
