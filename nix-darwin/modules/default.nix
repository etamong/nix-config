# Main modules entry point
{ config, lib, pkgs, ... }:
{
  imports = [
    ./system
    ./themes
    ./users
  ];
}