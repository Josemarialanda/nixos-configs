{ inputs, outputs, lib, config, pkgs, config-variables, ... }:
{
  imports = [ 
    ./apps
    ./secrets.nix
     ];
}