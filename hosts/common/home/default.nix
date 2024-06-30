{ inputs, outputs, lib, config, pkgs, config-variables, ... }:
{
  imports = [ 
    ./apps
    ./secrets.nix
     ];

  # Reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}