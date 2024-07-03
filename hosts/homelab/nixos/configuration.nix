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

  # Enable AMD gpu support
  amd.enable = true;

  # Enable Remote services
  remote.enable = true;

  # Setup SSH access
  ssh.enable = true;
  ssh.authorizedKeys = [
    # Macbook Air 15
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2BDbRCviyY2EiJr2+wFajynAbFiqbgEte7oalmq+ek jose@mac-jose"
    # NixOS Workstation
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCGFKh9q22zYVZcbuKNNvq4iELrWvF1VRrjo4GEU/LL josemaria@workstation"
  ];

  # Enable Virtualisation services
  virtualisation.enable = true;
}
