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
  # In order to access the service, you need to be connected to TailScale VPN.
  # Open the service in your browser at http://100.119.151.18:3000
  services.audiobookshelf = {
    enable = true;
    host = "100.119.151.18";
    port = 3000;
    user = config-variables.username;
  };

  # Setup Cachix for binary cache.
  # nix.settings.trusted-substituters = [];
  # nix.settings.trusted-public-keys = [];

  # Temperature kernel driver.
  boot.kernelModules = ["nct6775"];

  # Supported file systems.
  boot.supportedFilesystems = ["ntfs"];
}
