{ pkgs, lib, config, ... }:
{

  options = {
    devices.logitech.enable = lib.mkEnableOption "Enable logitech device support";
  };

  config = {
    hardware.logitech.wireless.enable = config.devices.logitech.enable;
    hardware.logitech.wireless.enableGraphical = config.devices.logitech.enable;
  };
}