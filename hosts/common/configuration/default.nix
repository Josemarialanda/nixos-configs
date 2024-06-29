{ inputs, outputs, pkgs, lib, config, config-variables, ... }:
{
  imports = [ 
    (import ./networking.nix {inherit pkgs lib config config-variables;})
    (import ./gui {inherit pkgs lib config config-variables;})
    (import ./nix.nix {inherit pkgs lib config inputs config-variables;})
    (import ./ssh.nix {inherit pkgs lib config config-variables;})
    (import ./users.nix {inherit config config-variables;})
    (import ./common.nix {inherit pkgs;})
    (import ./gpu { inherit pkgs lib config config-variables; })
    ./sound.nix
    ./locale.nix
    ./virtualisation.nix
    ./remote.nix
    ./fonts.nix
    ./gaming.nix
    ./devices.nix
     ];
}