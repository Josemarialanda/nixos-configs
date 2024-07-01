{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    amd.enable = lib.mkEnableOption "Enable AMD gpu support";
  };

  config = lib.mkIf config.amd.enable {
    # Load the 'amdgpu' kernel module in the first stage of the boot process.
    boot.initrd.kernelModules = ["amdgpu"];

    # Enable OpenCL support for AMD GPUs.
    hardware.opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    # Enable Vulkan support for AMD GPUs.
    hardware.opengl.driSupport = true; # This is already enabled by default
    hardware.opengl.driSupport32Bit = true; # For 32 bit applications
  };
}
