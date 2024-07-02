{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  config-variables,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../common/configuration
  ];

  # Enable AMD gpu support
  amd.enable = true;

  # Enable Remote services
  remote.enable = true;

  # Setup SSH access
  ssh.enable = true;
  ssh.authorizedKeys = [
    # Macbook Air 15
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxyLVSAu/qQKRj27OMbxFkfyIBOSaq7tkhwfwa9zMTR3bv6u9nr1d/B8TU+4fa4Na26565H9FHfirT9c8xc/hAuW43f30YZT6T+Ih2rYNk4RkUUpbafAk9Uh3qeQXP+I/y0avzqPqj5R46A8c9AvmC6Rytn1bl8aPm3DogPvqPaIDN9nkmkXf/F9RS+HinjWB3+gB2KBi4Utn14j+BbVVWeozpxx/4NOgsKHc4HymYipD4aFiXe3mpy0KOJnNvV3rPMqzYZtxvArISsAl3k/emwNsERy67ZArmPB/SDCn8n9Fy3nFAgLDyRefYCeNH5jrOfJOVI+2UxZhJXQbQsrxVJLFBkbAE6BFo+V9h2fshNoDpvuLUPC3SjR40OY035v6wj31tzYCnmC9QB6VQ2UWSpWzkwFUp5i9KMLvOOvi9FJMVHJP7Ftu14meqcxr8BkjfsMpnQ0p+h1m+cbSgr7IpF5L12eDWReV2O0RlJlFbUDHQMqNdGWNmqM/CMOsIhYM= jose@Joses-Laptop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCGFKh9q22zYVZcbuKNNvq4iELrWvF1VRrjo4GEU/LL josemaria@workstation"
  ];

  # Enable Virtualisation services
  virtualisation.enable = true;
}
