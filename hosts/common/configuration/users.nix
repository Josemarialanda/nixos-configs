{ config, config-variables }:
{
  users.users.${config-variables.username} = {
    isNormalUser = true;
    description = config-variables.userDesc;
    extraGroups = 
      [  "networkmanager" "wheel" ] ++ 
      (if config.virtualisation.enable == true 
        then [ "qemu" "libvirtd" "kvm" ] 
        else []);
  };
}