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

  # Enable GUI
  gui.enable = true;

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

  # Setup Cachix for binary cache.
  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];

  # Temperature kernel driver.
  boot.kernelModules = ["nct6775"];

  # Supported file systems.
  boot.supportedFilesystems = ["ntfs"];
}
