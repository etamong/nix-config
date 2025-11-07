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

    nixvim = {
      url = "github:nix-community/nixvim";
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

    zsh-autopair = {
      url = "github:hlissner/zsh-autopair";
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
    nixvim,
    saml2aws,
    zsh-powerlevel10k,
    zsh-autopair,
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
    system = "aarch64-darwin";
    username = "jhlee";
    
    # Shared overlays for both darwin and home-manager
    sharedOverlays = [
      (final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      })
      (final: prev: {
        saml2aws = saml2aws.packages.${system}.default;
      })
    ];
    
    # Create a shared configuration with overlays
    sharedConfig = { pkgs, ... }: {
      nixpkgs.overlays = sharedOverlays;
    };
    
    # Create pkgs with overlays for home-manager
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = sharedOverlays;
    };
    
    # Special args for all configurations
    specialArgs = {
      inherit username zsh-powerlevel10k zsh-autopair;
      inherit vim-nord vim-surround vim-commentary vim-easy-align fzf-vim vim-fugitive vim-nix vim-terraform vim-go;
      inherit saml2aws;
    };
  in
  {
    
    darwinConfigurations = {
      "etamong-macbook8" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = specialArgs;
        modules = [
          ./modules/darwin
          sharedConfig
          {
            system.configurationRevision = self.rev or self.dirtyRev or null;
            nixpkgs.hostPlatform = system;
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users = {
              jhlee = import ./home/jhlee.nix;
            };
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
          }
        ];
      };
      "macbook-jooholee" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = specialArgs;
        modules = [
          ./modules/darwin
          sharedConfig
          {
            system.configurationRevision = self.rev or self.dirtyRev or null;
            nixpkgs.hostPlatform = system;
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users = {
              jhlee = import ./home/jhlee.nix;
            };
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
          }
        ];
      };
    };
    
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = specialArgs;
      modules = [
        ./home/jhlee.nix
      ];
    };
  };
}
