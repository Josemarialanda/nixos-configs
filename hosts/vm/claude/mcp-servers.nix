# MCP servers, packaged from nixpkgs.
# GitHub access goes through the `gh` CLI (see ../home.nix), which costs fewer tokens than an MCP server.
{
  lib,
  pkgs,
  ...
}: {
  nixos = {
    type = "stdio";
    command = lib.getExe pkgs.unstable.mcp-nixos;
  };
  playwright = {
    type = "stdio";
    command = lib.getExe pkgs.unstable.playwright-mcp;
    args = ["--headless"];
  };
  # Up-to-date library documentation.
  context7 = {
    type = "stdio";
    command = lib.getExe pkgs.unstable.context7-mcp;
  };
}
