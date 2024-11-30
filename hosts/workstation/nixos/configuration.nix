{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  config-variables,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../common/configuration
  ];

  # Enable Gnome desktop environment
  gnome.enable = true;

  # Enable GDM auto login
  gdm.autoLogin.enable = true;

  # Enable AMD gpu support
  amd.enable = true;

  # Enable Logitech devices
  devices.logitech.enable = true;

  # Enable extra fonts
  extraFonts.enable = true;

  # Enable Remote services
  remote.enable = true;

  # Enable sound
  soundServer.enable = true;

  # Setup SSH access
  ssh.enable = true;

  # Enable Virtualisation services
  virtualisation.enable = true;

  # Enable Steam
  programs.steam.enable = true;

  # Enable AudioBookshelf audiobook manager.
  # Accessible through local network at http://192.168.1.252:3000
  services.audiobookshelf = {
    enable = true;
    # Listen for incoming connections on all network interfaces.
    host = "0.0.0.0";
    port = 3000;
    user = config-variables.username;
    openFirewall = true;
  };

  # Setup Cachix for binary cache.
  # nix.settings.trusted-substituters = [];
  # nix.settings.trusted-public-keys = [];

  # Temperature kernel driver.
  boot.kernelModules = ["nct6775"];

  # Supported file systems.
  boot.supportedFilesystems = ["ntfs"];
}
