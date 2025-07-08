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
  };

  outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs, nixpkgs-unstable, saml2aws }:
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
