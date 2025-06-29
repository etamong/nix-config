{
    description = "Example nix-darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs }: {
        # 1. First-time installation:
        # $ nix run nix-darwin -- switch --flake .#jhlee-macbook8
        #
        # 2. Subsequent rebuilds:
        # $ darwin-rebuild switch --flake .#jhlee-macbook8
        darwinConfigurations = {
          "jhlee-macbook8" = nix-darwin.lib.darwinSystem {
            modules = [
                ./configuration.nix
                {
                  # Set Git commit hash for darwin-version.
                  system.configurationRevision = self.rev or self.dirtyRev or null;
                }
                home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.jhlee = ./home.nix;

                  # Optionally, use home-manager.extraSpecialArgs to pass
                  # arguments to home.nix
                }
            ];
          };
        };
        darwinPackages = self.darwinConfigurations."jhlee-macbook8".pkgs;
    };
}
