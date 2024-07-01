{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    extraFonts.enable = lib.mkEnableOption "Add additional fonts";
  };

  config = lib.mkIf config.extraFonts.enable {
    fonts.packages = with pkgs; [
      fira-code
      cascadia-code
    ];
  };
}
