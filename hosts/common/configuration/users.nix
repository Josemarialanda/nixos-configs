{
  config,
  config-variables,
  ...
}: {
  users.users.${config-variables.username} = {
    isNormalUser = true;
    description = config-variables.userDesc;
    extraGroups = ["networkmanager" "wheel"];
  };
}
