{ pkgs, lib, config, config-variables, ... }:
{

  options = {
    gui.enable = lib.mkEnableOption "Enable GUI";
    gui.enableAutoLogin = lib.mkEnableOption "Enable GDM automatic login";
  };
  
  imports = [ 
    (import ./desktopEnvironment.nix {inherit pkgs lib config config-variables;})
    ./desktopServices.nix
  ];

  config = lib.mkIf config.gui.enable {

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = config.gui.enableAutoLogin;
    services.displayManager.autoLogin.user = config-variables.username;

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = !config.gui.enableAutoLogin;
    systemd.services."autovt@tty1".enable = !config.gui.enableAutoLogin;
  };
}