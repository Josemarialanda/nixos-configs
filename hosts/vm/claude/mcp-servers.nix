# MCP servers, packaged from nixpkgs.
{
  config,
  lib,
  pkgs,
  ...
}: let
  # Reads the token from the decrypted secret at startup, so it never ends up in the Nix store.
  githubMcpServer = pkgs.writeShellScript "github-mcp-server" ''
    GITHUB_PERSONAL_ACCESS_TOKEN=$(cat "${config.age.secrets.github-token.path}")
    export GITHUB_PERSONAL_ACCESS_TOKEN
    exec ${lib.getExe pkgs.unstable.github-mcp-server} stdio
  '';
in {
  nixos = {
    type = "stdio";
    command = lib.getExe pkgs.unstable.mcp-nixos;
  };
  playwright = {
    type = "stdio";
    command = lib.getExe pkgs.unstable.playwright-mcp;
    args = ["--headless"];
  };
  github = {
    type = "stdio";
    command = "${githubMcpServer}";
  };
}
