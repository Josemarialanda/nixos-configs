{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    virtualisation.enable = lib.mkEnableOption "Enable virtualisation";
  };

  config = lib.mkIf config.virtualisation.enable {
    # Enable Podman.
    virtualisation.podman = {
      enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # Create an alias mapping docker to podman.
      dockerCompat = true;
    };

    # Enable libvirtd, a daemon that manages virtual machines.
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };
    };
  };
}
