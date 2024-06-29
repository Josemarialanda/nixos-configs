{ inputs, outputs, lib, config, pkgs, config-variables, ... }:
{

  options = {
    systemType = lib.mkOption {
      type = with lib.types; str;
      default = "full";
      description = "CLI, GUI or both?";
    }; 
  };
  
  imports = [ 
    ./cli.nix
    ./gui.nix
  ];

  config = { 
    cli.enable = 
      if config.systemType == "cli" ||
         config.systemType == "full"
        then true
        else false;
    gui.enable = 
      if config.systemType == "gui" ||
         config.systemType == "full"
        then true
        else false;
  };
}