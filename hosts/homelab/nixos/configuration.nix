{ inputs, outputs, pkgs, lib, config, config-variables, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ../../common/configuration
     ];

  # Enable AMD gpu support
  amd.enable = true;
  
  # Enable Remote services
  remote.enable = true;

  # Setup SSH access
  ssh.enable = true;
  ssh.authorizedKeys = [

  ];

  # Enable Virtualisation services
  virtualisation.enable = true;
}