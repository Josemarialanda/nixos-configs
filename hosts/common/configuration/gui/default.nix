{
  pkgs,
  lib,
  config,
  config-variables,
  ...
}: {
  options = {
    gui.enable = lib.mkEnableOption "Enable GUI";
  };

  imports = [
    (import ./desktopEnvironment.nix {inherit pkgs lib config config-variables;})
    ./desktopServices.nix
  ];

  config = lib.mkIf config.gui.enable {
    desktopEnvironment.enable = config.gui.enable;
    desktopServices.enable = config.gui.enable;
  };
}
