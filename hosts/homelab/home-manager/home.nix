{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  config-variables,
  ...
}: {
  programs.home-manager.enable = true;
  home.username = config-variables.username;
  home.homeDirectory = "/home/" + config-variables.username;
  home.stateVersion = config-variables.stateVersion;

  imports = [
    ../../common/home
  ];

  home.packages = let
    cli-tools = import ../../common/cli-tools.nix;
  in
    with pkgs; [];
}
