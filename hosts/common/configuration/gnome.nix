{
  pkgs,
  lib,
  config,
  config-variables,
  ...
}: {
  options = {
    gnome.enable = lib.mkEnableOption "Enable Gnome desktop environment";
    gdm.autoLogin.enable = lib.mkEnableOption "Enable automatic login";
  };

  imports = [
    ./desktopServices.nix
  ];

  config = lib.mkIf config.gnome.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Setup GNOME desktop environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = config.gdm.autoLogin.enable;
    services.displayManager.autoLogin.user = config-variables.username;

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = !config.gdm.autoLogin.enable;
    systemd.services."autovt@tty1".enable = !config.gdm.autoLogin.enable;

    # Make GDM follow desktop monitor config. (uses user set refresh rate).
    systemd.tmpfiles.rules = let
      gdm_monitors_xml = builtins.readFile "/home/${config-variables.username}/.config/monitors.xml";
      monitorsConfig = pkgs.writeText "gdm_monitors.xml" gdm_monitors_xml;
    in ["L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"];

    # Disable the XTerm terminal emulator.
    services.xserver.excludePackages = [pkgs.xterm];

    # Enable Remote Desktop support.
    services.gnome.gnome-remote-desktop.enable = true;

    # Exclude some default GNOME applications.
    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-tour
        snapshot
        gnome-connections
      ])
      ++ (with pkgs.gnome; [
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

    # Add some additional GNOME applications.
    environment.systemPackages = with pkgs; [ 
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      gnomeExtensions.dash-to-dock
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.app-hider
      adwsteamgtk
    ];

    # Enable Sushi, a quick previewer for nautilus.
    services.gnome.sushi.enable = true;

    # Configure GNOME.
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            # Custom keybindings.
            "org/gnome/settings-daemon/plugins/media-keys" = {
              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              binding = "<Super>Return";
              command = "kgx";
              name = "GNOME Console";
            };
          };
        }
      ];
    };

    # Enable desktop services.
    desktopServices.enable = true;
  };
}
