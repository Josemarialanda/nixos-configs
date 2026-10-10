{
  inputs,
  config,
  host,
  ...
}: {
  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ./bash.nix
    ./git.nix
  ];

  home = {
    inherit (host) username stateVersion;
    homeDirectory = "/home/${host.username}";
  };
  programs.home-manager.enable = true;

  # Reload user units when changing configs.
  systemd.user.startServices = "sd-switch";

  # Key used by agenix to decrypt secrets.
  age.identityPaths = ["${config.home.homeDirectory}/.ssh/secrets-key"];

  # nix-index database + comma (`, <cmd>` runs commands without installing).
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
