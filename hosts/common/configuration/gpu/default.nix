{ pkgs, lib, config, config-variables, ... }:
{

  options = {
    gpuType = lib.mkOption {
      type = with lib.types; str;
      default = "amd";
      description = "AMD or Nvidia?";
    }; 
  };
  
  imports = [ 
    ./nvidia.nix
    ./amd.nix
  ];

  config = lib.mkIf config.gui.enable { 
    nvidia.enable = config.gpuType == "nvidia";
    amd.enable = config.gpuType == "amd";
  };
}