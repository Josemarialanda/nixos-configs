{ pkgs, lib, config, ... }:
{

  options = {
    soundServer.enable = lib.mkEnableOption "Enable sound";
  };

  config = lib.mkIf config.soundServer.enable {
  
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}