# Every file in ./output-styles. There's no outputStylesDir option, so this reads the directory.
{lib, ...}:
lib.mapAttrs'
(file: _: lib.nameValuePair (lib.removeSuffix ".md" file) ./output-styles/${file})
(builtins.readDir ./output-styles)
