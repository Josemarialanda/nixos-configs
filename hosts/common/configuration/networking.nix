{ pkgs, lib, config, config-variables, ... }:
{
  # Setup networking.
  networking.networkmanager.enable = true;
  networking.hostName = config-variables.hostname;
  
  # Open ports 80 and 443 for HTTP and HTTPS.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}