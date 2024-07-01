{
  lib,
  config,
  ...
}: {
  options = {
    desktopServices.enable = lib.mkEnableOption "Enable desktop services";
  };

  config = lib.mkIf config.desktopServices.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
