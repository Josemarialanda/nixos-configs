{ pkgs, lib, config, config-variables, ... }:
{
    
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Setup GNOME desktop environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  
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
}