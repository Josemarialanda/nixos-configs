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
    networking.firewall.checkReversePath = "loose";

    # Enable Sunshine remote desktop service.
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;
      settings.port = 47989;
      applications.apps = [
        {
          name = "2880x1864@60hz";
          prep-cmd = [
            {
              do = ''${pkgs.xorg.xrandr}/bin/xrandr --newmode "2880x1864_60.00"  457.75  2880 3104 3416 3952  1864 1867 1877 1931 -hsync +vsync'';
              undo = ''${pkgs.xorg.xrandr}/bin/xrandr --rmmode 2880x1864_60.00'';
            }
            {
              do = ''${pkgs.xorg.xrandr}/bin/xrandr --addmode DP-1 2880x1864_60.00'';
              undo = ''${pkgs.xorg.xrandr}/bin/xrandr --delmode DP-1 2880x1864_60.00'';
            }
            {
              do = ''${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 2880x1864_60.00'';
              undo = ''${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 2560x1440 --rate 144'';
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "3840x2160@60hz";
          prep-cmd = [
            {
              do = ''${pkgs.xorg.xrandr}/bin/xrandr --newmode "3840x2160_60.00"  457.75  2880 3104 3416 3952  1864 1867 1877 1931 -hsync +vsync'';
              undo = ''${pkgs.xorg.xrandr}/bin/xrandr --rmmode 3840x2160_60.00'';
            }
            {
              do = ''${pkgs.xorg.xrandr}/bin/xrandr --addmode DP-1 3840x2160_60.00'';
              undo = ''${pkgs.xorg.xrandr}/bin/xrandr --delmode DP-1 3840x2160_60.00'';
            }
            {
              do = ''${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode 3840x2160_60.00'';
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
