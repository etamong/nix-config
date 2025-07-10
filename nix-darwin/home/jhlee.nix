{ config, pkgs, ... }: {
  # Import all modules
  imports = [
    ../modules/home
    ../modules/podman
    ../modules/programs
    ../modules/users/jhlee.nix
    ../modules/themes
    ../modules/zsh
  ];
}
