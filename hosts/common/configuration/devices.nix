{
  lib,
  config,
  ...
}: {
  options = {
    devices.logitech.enable = lib.mkEnableOption "Enable logitech device support";
  };

  config = lib.mkIf config.devices.logitech.enable {
    # Enable support for Logitech Wireless Devices.
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;

    # Improved Linux module drivers for Logitech driving wheels.
    hardware.new-lg4ff.enable = true;

    # Disable USB power management for Logitech devices. (Fixes wake-up issues)
    # Logitech Logi Bolt: 046d:c548
    # Logitech USB recevier: 046d:c52b
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", ATTR{power/wakeup}="disabled"
    '';

  };
}
