{ lib, config, ... }:
{

  options = {
    gaming.enable = lib.mkEnableOption "Add gaming stuff";
  };

  config = lib.mkIf config.gaming.enable {

    programs.steam.enable = true;
  };
}