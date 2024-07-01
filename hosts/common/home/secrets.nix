{
  inputs,
  config-variables,
  ...
}: {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  # Setup encryption key
  age.identityPaths = ["/home/${config-variables.username}/.ssh/secrets-key"];
}
