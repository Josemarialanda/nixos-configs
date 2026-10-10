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
    modelSettings.claude-opus-5-5.effortLevel = "medium";
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
