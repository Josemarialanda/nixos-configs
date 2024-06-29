{ pkgs, lib, config, config-variables, ... }:
{

  options = {
    ssh.enable = lib.mkEnableOption "Enable ssh";
    ssh.authorizedKeys = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "Authorized SSH keys.";
    }; 
  };

  config = lib.mkIf config.ssh.enable {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  
    # Start the OpenSSH agent on log in.
    programs.ssh.startAgent = true;

    # Authorized keys.
    users.users.${config-variables.username}.openssh.authorizedKeys.keys = config.ssh.authorizedKeys;

  };
}