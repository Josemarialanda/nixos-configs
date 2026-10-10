# Every .md file in ./output-styles, keyed by name without the extension.
# There's no outputStylesDir option, so this reads the directory.
{lib, ...}: let
  dir = ./output-styles;
  isStyle = file: type: type == "regular" && lib.hasSuffix ".md" file;
  styles = lib.filterAttrs isStyle (builtins.readDir dir);
in
  lib.mapAttrs' (file: _: lib.nameValuePair (lib.removeSuffix ".md" file) (dir + "/${file}")) styles
