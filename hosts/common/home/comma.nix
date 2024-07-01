{inputs, ...}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];
  programs = {
    # Enable the nix-index database & Comma
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };
}
