{
    description = "nix-darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        home-manager.url = "github:nix-community/home-manager/release-24.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        home-manager-unstable.url = "github:nix-community/home-manager";
        home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs }: {
        darwinConfigurations = {
          "jhlee-macbook8" = nix-darwin.lib.darwinSystem {
            modules = [
                ./configuration.nix
                {
                  system.configurationRevision = self.rev or self.dirtyRev or null;
                  nixpkgs.hostPlatform = "aarch64-darwin";
                }
                home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.jhlee = import ./home.nix;
                }
            ];
          };
        };
        darwinPackages = self.darwinConfigurations."jhlee-macbook8".pkgs;
    };
}
