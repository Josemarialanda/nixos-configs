{ lib, config, ... }:
{

  options = {
    amd.enable = lib.mkEnableOption "Enable AMD gpu support";
  };

  config = lib.mkIf config.amd.enable {

    # Load the 'amdgpu' kernel module in the first stage of the boot process.
    boot.initrd.kernelModules = [ "amdgpu" ];    
  };
}