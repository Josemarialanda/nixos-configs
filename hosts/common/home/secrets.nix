{ inputs, outputs, lib, config, pkgs, config-variables, ... }:

{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  # # Create symlinks to decrypted secrets.
  # age = {
  #   identityPaths = [ "/home/${config-variables.username}/.ssh/secrets-key" ];
  #   secrets = {
  #     gh-ssh-key = {
  #       file = ./secrets/gh-ssh-key.age;
  #       path = "/home/${config-variables.username}/.ssh/gh-ssh-key";
  #       mode = "600";
  #     };
  #   };
  # };

}