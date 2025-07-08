{ config, pkgs, ... }: {
  # Import all modules
  imports = [
    ../modules/home
    ../modules/programs
    ../modules/users/jhlee.nix
    ../modules/themes
  ];
}
