{pkgs, ...}: {
  # Bootloader settings.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest Linux kernel.
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Enable SSD TRIM support.
  services.fstrim.enable = true;

  # Run unpatched dynamic binaries on NixOS.
  programs.nix-ld.enable = true;
}
