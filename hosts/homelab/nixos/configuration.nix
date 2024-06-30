{ inputs, outputs, pkgs, lib, config, config-variables, ... }@args:
{
  imports = [ 
    ./hardware-configuration.nix
    ../../common/configuration
     ];

  # Enable the Gnome DE and automatic login.
  gui.enable = true;
  gui.enableAutoLogin = true; 

  # Add additional fonts to system.
  extraFonts.enable = true;

  # Enable Tailscale and Sunshine.
  remote.enable = true;

  # Enable Sound.
  soundServer.enable = true;

  # Enable virtualisation.
  virtualisation.enable = true;

  # Setup AMD GPU drivers.
  amd.enable = true;

  # Setup ssh.
  ssh.enable = true;
  ssh.authorizedKeys = [];

  system.stateVersion = config-variables.stateVersion;
}