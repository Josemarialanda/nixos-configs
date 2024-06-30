{ inputs, outputs, lib, config, pkgs, config-variables, ... }:
{

  options = {
    apps.common.include = lib.mkOption {
      type = with lib.types; str;
      default = "all";
      description = "CLI, GUI or both?";
    }; 
  };
  
  imports = [ 
    ./cli.nix
    ./gui.nix
  ];

  config = { 

    nixpkgs = {
      overlays = [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages
      ];
      config = {
        allowUnfree = true;
        # Workaround for https://github.com/nix-community/home-manager/issues/2942
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ ];
      };
    };

    cli.enable = 
      if config.apps.common.include == "cli" ||
         config.apps.common.include == "all"
        then true
        else false;
    gui.enable = 
      if config.apps.common.include == "gui" ||
         config.apps.common.include == "all"
        then true
        else false;
  };
}