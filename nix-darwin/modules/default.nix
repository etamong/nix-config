# Main modules entry point
{ config, lib, pkgs, ... }:
{
  imports = [
    ./system
    ./home
    ./themes
    ./programs
    ./users
  ];
}