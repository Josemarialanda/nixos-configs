{ inputs, outputs, pkgs, lib, config, config-variables, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ../../common/configuration
     ];

  # Disable GUI
  gui.enable = false;

  # Enable AMD gpu support
  amd.enable = true;

  # Disable Logitech devices
  devices.logitech.enable = false;

  # Disable extra fonts
  extraFonts.enable = false;

  # Disable Steam
  gaming.enable = false;
  
  # Enable Remote services
  remote.enable = true;

  # Disable sound
  soundServer.enable = false;

  # Setup SSH access
  ssh.enable = true;
  ssh.authorizedKeys = [

  ];

  # Enable Virtualisation services
  virtualisation.enable = true;
}