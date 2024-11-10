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

  home.packages = with pkgs; [];

  age.secrets = {
    gh-ssh-key = {
      file = ./secrets/gh-ssh-key.age;
      path = "/home/${config-variables.username}/.ssh/gh-ssh-key";
      mode = "600";
    };
  };
}
