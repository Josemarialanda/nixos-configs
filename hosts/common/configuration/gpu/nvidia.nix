{ pkgs, lib, config, ... }:

{
  options = {
    nvidia.enable = lib.mkEnableOption "Enable Nvidia gpu support";
  };

  config = lib.mkIf config.nvidia.enable {

    nixpkgs.config.allowUnfree = true;

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau ];
    };
    
    # Setup Nvidia drivers.
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}