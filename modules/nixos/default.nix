{host, ...}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./ssh.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = host.hostname;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [80 443];
  };

  users.users.${host.username} = {
    isNormalUser = true;
    description = host.userDesc;
    extraGroups = ["networkmanager" "wheel"];
  };

  # SSD TRIM.
  services.fstrim.enable = true;

  # Run unpatched dynamic binaries.
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = host.stateVersion;
}
