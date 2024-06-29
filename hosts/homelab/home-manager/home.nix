{ inputs, outputs, lib, config, pkgs, config-variables, ... }:

{
  programs.home-manager.enable = true;
  home.username = config-variables.username;
  home.homeDirectory = "/home/" + config-variables.username;
  home.stateVersion = config-variables.stateVersion;
  
  imports = [
    ../../common/home
  ];

  systemType = "full";

  # Reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}