# ~/.claude/settings.json.
{
  config,
  lib,
  pkgs,
  ...
}: let
  # Runs a script from ./hooks, with the tools the hooks need on PATH.
  claudeHook = name: {
    type = "command";
    command = "PATH=${lib.makeBinPath [pkgs.jq]}:$PATH ${config.programs.claude-code.configDir}/hooks/${name}";
  };
in {
  programs.claude-code.settings = {
    theme = "auto";
    outputStyle = "Concise";
    modelSettings.claude-opus-5-5.effortLevel = "medium";

    env = {
      # Limit command output, so that one large log cannot fill the context.
      BASH_MAX_OUTPUT_LENGTH = "15000";
      MAX_MCP_OUTPUT_TOKENS = "10000";
      # Remove colour codes and pagers from command output.
      NO_COLOR = "1";
      PAGER = "cat";
      GIT_PAGER = "cat";
    };

    hooks = {
      PreToolUse = [
        {
          matcher = "Bash";
          hooks = [(claudeHook "block-dangerous-commands.sh")];
        }
        {
          matcher = "Read|Edit|MultiEdit|Write|NotebookEdit";
          hooks = [(claudeHook "protect-sensitive-files.sh")];
        }
      ];
      PostToolUse = [
        {
          matcher = "Edit|MultiEdit|Write";
          hooks = [(claudeHook "format-on-edit.sh")];
        }
      ];
    };
  };

  # Claude Code can replace the settings.json link with a regular file when saving settings
  # from its UI, so overwrite it on every switch.
  home.file."${config.programs.claude-code.configDir}/settings.json".force = true;
}
