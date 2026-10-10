{
  config,
  lib,
  pkgs,
  ...
}: let
  # Arguments for the Nix files in ./claude.
  claudeArgs = {inherit config lib pkgs;};
in {
  imports = [../../modules/home];

  home.packages = [];

  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    context = ./claude/CLAUDE.md;
    agentsDir = ./claude/agents;
    commandsDir = ./claude/commands;
    hooksDir = ./claude/hooks;
    skills = ./claude/skills;
    outputStyles = import ./claude/output-styles.nix claudeArgs;
    mcpServers = import ./claude/mcp-servers.nix claudeArgs;
    settings = import ./claude/settings.nix claudeArgs;
  };

  # Claude Code can replace the settings.json link with a regular file when saving settings
  # from its UI, so overwrite it on every switch. Persistent settings belong in claude/settings.nix.
  home.file."${config.programs.claude-code.configDir}/settings.json".force = true;

  age.secrets = {
    gh-ssh-key = {
      file = ./secrets/gh-ssh-key.age;
      path = "${config.home.homeDirectory}/.ssh/gh-ssh-key";
      mode = "600";
    };

    # Used by the GitHub MCP server in claude/mcp-servers.nix.
    github-token = {
      file = ./secrets/github-token.age;
    };
  };

  home.file.".ssh/config".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ${config.age.secrets.gh-ssh-key.path}
  '';
}
