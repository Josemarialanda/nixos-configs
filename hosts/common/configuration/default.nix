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
    ./gui
    ./networking.nix
    ./nix.nix
    ./ssh.nix
    ./users.nix
    ./common.nix
    ./amd.nix
    ./sound.nix
    ./locale.nix
    ./virtualisation.nix
    ./remote.nix
    ./fonts.nix
    ./devices.nix
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = config-variables.stateVersion;
}
