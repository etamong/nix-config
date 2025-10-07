# System-level configurations
{ config, lib, pkgs, ... }:
{
  imports = [
    ./darwin.nix
    ./packages.nix
    ./homebrew.nix
  ];
}