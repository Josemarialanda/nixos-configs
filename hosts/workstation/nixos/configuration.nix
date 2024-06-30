{ inputs, outputs, pkgs, lib, config, config-variables, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ../../common/configuration
     ];

  # Enable GUI
  gui.enable = true;

  # Enable Automatic login
  enableAutoLogin = false;

  # Enable AMD gpu support
  amd.enable = true;

  # Enable Logitech devices
  devices.logitech.enable = true;

  # Enable extra fonts
  extraFonts.enable = true;

  # Enable Steam
  gaming.enable = true;
  
  # Enable Remote services
  remote.enable = true;

  # Enable sound
  soundServer.enable = true;

  # Setup SSH access
  ssh.enable = true;

  # Enable Virtualisation services
  virtualisation.enable = true;

  # Temperature kernel driver.
  boot.kernelModules = [ "nct6775" ];

  # Supported file systems.
  boot.supportedFilesystems = [ "ntfs" ];
}