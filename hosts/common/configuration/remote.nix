{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    remote.enable = lib.mkEnableOption "Enable Remote services";
  };

  config = lib.mkIf config.remote.enable {

    # Enable Tailscale client daemon.
    services.tailscale.enable = true;

    # Need to allow tailscale + mullvad-vpn integration.
    # networking.firewall.checkReversePath = "loose";

    # Enable Mullvad VPN client daemon.
    # services.mullvad-vpn = {
    #   enable = true;
    #   package = pkgs.mullvad-vpn;
    # };

    # Enable Sunshine remote desktop service.
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;
      settings.port = 47989;
      applications.apps = [
        {
          name = "1920x1080@120hz";
          prep-cmd = [
            {
              do = ''${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 --rate 120'';
              undo = ''${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 2560x1440 --rate 144'';
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
