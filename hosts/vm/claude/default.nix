# Claude Code for the vm host. See README.md.
{
  config,
  lib,
  pkgs,
  ...
}: let
  # Arguments for the Nix files in this directory.
  claudeArgs = {inherit config lib pkgs;};
in {
  imports = [./settings.nix];

  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    context = ./CLAUDE.md;
    agentsDir = ./agents;
    commandsDir = ./commands;
    hooksDir = ./hooks;
    rulesDir = ./rules;
    skills = ./skills;
    outputStyles = import ./output-styles.nix claudeArgs;
    mcpServers = import ./mcp-servers.nix claudeArgs;
  };
}
