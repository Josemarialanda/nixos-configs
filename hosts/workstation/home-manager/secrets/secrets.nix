let
  secrets-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgb7h4Kon+rL5f7+QsOJMVc7UYQ0vr+KJ6Iuc9ctATM nixos@nixos";
in {
  "gh-ssh-key.age".publicKeys = [secrets-key];
  "id_ed25519.age".publicKeys = [secrets-key];
}
