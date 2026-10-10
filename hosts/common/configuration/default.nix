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
    ./networking.nix
    ./nix.nix
    ./ssh.nix
    ./users.nix
    ./common.nix
    ./locale.nix
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = config-variables.stateVersion;
}
