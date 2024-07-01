{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  config-variables,
  ...
}: {
  imports = [
    ./secrets.nix
    ./bash.nix
    ./comma.nix
    ./direnv.nix
    ./git.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [];
    };
  };

  # Reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
