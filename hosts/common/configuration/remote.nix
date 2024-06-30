{ pkgs, lib, config, ... }:
{

  options = {
    remote.enable = lib.mkEnableOption "Enable Remote services";
  };

  config = lib.mkIf config.remote.enable {
    
    # Enable Tailscale client daemon.
    services.tailscale.enable = true;

  };
}