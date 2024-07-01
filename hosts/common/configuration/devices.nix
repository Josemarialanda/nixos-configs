{
  lib,
  config,
  ...
}: {
  options = {
    devices.logitech.enable = lib.mkEnableOption "Enable logitech device support";
  };

  config = lib.mkIf config.devices.logitech.enable {
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
  };
}
