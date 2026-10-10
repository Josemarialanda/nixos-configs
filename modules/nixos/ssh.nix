{
  lib,
  config,
  host,
  ...
}: let
  cfg = config.my.ssh;
in {
  options.my.ssh = {
    enable = lib.mkEnableOption "the OpenSSH server";
    authorizedKeys = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "SSH public keys allowed to log in as the primary user.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    programs.ssh.startAgent = true;
    users.users.${host.username}.openssh.authorizedKeys.keys = cfg.authorizedKeys;
  };
}
