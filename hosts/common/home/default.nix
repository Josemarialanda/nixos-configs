{ inputs, outputs, lib, config, pkgs, config-variables, ... }:
{
  imports = [ 
    ./secrets.nix
    ./bash.nix
    ./comma.nix
    ./direnv.nix
    ./git.nix
     ];

  # Reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}