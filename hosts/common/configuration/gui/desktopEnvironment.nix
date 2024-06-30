{ pkgs, lib, config, config-variables, ... }:
{

  options = {
    desktopEnvironment.enable = lib.mkEnableOption "Enable desktop environment";
    enableAutoLogin = lib.mkEnableOption "Enable automatic login";
  };

  config = lib.mkIf config.desktopEnvironment.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    
    # Setup GNOME desktop environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = config.enableAutoLogin;
    services.displayManager.autoLogin.user = config-variables.username;

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = !config.enableAutoLogin;
    systemd.services."autovt@tty1".enable = !config.enableAutoLogin;
    
     # Make GDM follow desktop monitor config. (uses user set refresh rate).
    systemd.tmpfiles.rules =
      let gdm_monitors_xml = builtins.readFile "/home/${config-variables.username}/.config/monitors.xml";
          monitorsConfig = pkgs.writeText "gdm_monitors.xml" gdm_monitors_xml;
      in [ "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}" ];
    
    # Disable the XTerm terminal emulator.
    services.xserver.excludePackages = [ pkgs.xterm ];
    
    # Enable Remote Desktop support.
    services.gnome.gnome-remote-desktop.enable = true;
    
    # Exclude some default GNOME applications.
    environment.gnome.excludePackages = (with pkgs; [
      gnome-tour
      snapshot
      gnome-console
      gnome-connections
    ]) ++ (with pkgs.gnome; [
      epiphany
      geary
      gnome-characters
      gnome-font-viewer
      yelp
      simple-scan
      gnome-music
      totem
      gnome-shell-extensions
      gnome-contacts
      gnome-maps
    ]);
    
    # Enable Sushi, a quick previewer for nautilus.
    services.gnome.sushi.enable = true;
    
    # Enable dconf.
    programs.dconf.enable = true;
  };
}