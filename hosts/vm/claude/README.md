# Claude Code configuration

Claude Code configuration for the `vm` host: instructions, settings, hooks, agents, commands, skills, output styles and MCP servers.
It's installed by `programs.claude-code` in [`../home.nix`](../home.nix).

```
claude/
├── CLAUDE.md          # user-level instructions, becomes ~/.claude/CLAUDE.md (programs.claude-code.context)
├── settings.nix       # ~/.claude/settings.json, including hook registrations (programs.claude-code.settings)
├── mcp-servers.nix    # MCP servers (programs.claude-code.mcpServers)
├── output-styles.nix  # installs everything in output-styles/ (programs.claude-code.outputStyles)
├── agents/            # every file here becomes ~/.claude/agents/<file>
├── commands/          # every file here becomes ~/.claude/commands/<file>
├── hooks/             # every file here becomes ~/.claude/hooks/<file>; registered in settings.nix
├── output-styles/     # every file here becomes ~/.claude/output-styles/<file>
└── skills/            # every skill folder here becomes ~/.claude/skills/<folder>/
```

The `.nix` files are imported by [`../home.nix`](../home.nix), which passes them `config`, `lib` and `pkgs`.

## Agents

`agents/` is installed with `programs.claude-code.agentsDir`, which links the whole directory into `~/.claude/agents/`.
Every file in it is installed, so keep only agent `.md` files there.

| Agent | Tools | Use it for |
|---|---|---|
| `code-reviewer` | Read, Edit, Grep | General review of code quality, security and maintainability |
| `documentation` | Read, Edit, Write, Grep, Glob | Writing and updating READMEs, comments and usage examples |
| `test-writer` | Read, Edit, Write, Grep, Glob, Bash | Writing and running tests for new or changed code |
| `debugger` | Read, Edit, Grep, Glob, Bash | Finding the root cause of errors and test failures |
| `security-reviewer` | Read, Grep, Glob | Read-only security review of changes |
| `commit-writer` | Bash, Read (haiku) | Writing a commit message from the staged diff |

### Using an agent

Claude Code picks agents in two ways:

- **Automatically.** Claude reads each agent's `description` and hands a task to the agent whose description matches it.
  Descriptions that say "Use proactively when..." make this more likely.
- **Explicitly.** Name the agent in your prompt, for example:

  ```
  Use the debugger agent to figure out why the build fails
  Have the security-reviewer agent check my last commit
  ```

Run `/agents` inside Claude Code to see the agents it has loaded.

### Adding an agent

Create `agents/<name>.md`:

```markdown
---
name: my-agent
description: What it does and when Claude should use it.
tools: Read, Grep, Glob     # optional; omit to inherit all tools
model: sonnet               # optional; haiku, sonnet, opus or inherit
---

The system prompt for the agent.
```

No change to `home.nix` is needed. To remove an agent, delete its file.

## Commands

`commands/` is installed with `programs.claude-code.commandsDir`, which links the whole directory into `~/.claude/commands/`.
Every file in it is installed, so keep only command `.md` files there.

| Command | Use it for |
|---|---|
| `/changelog [version] [change-type] [message]` | Adding an entry to `CHANGELOG.md` |
| `/fix-issue [issue-number]` | Fixing a GitHub issue (needs `gh`) |
| `/commit` | Creating one atomic commit from the current changes |

### Adding a command

Create `commands/<name>.md`. The file name becomes the command, so `my-command.md` is `/my-command`:

```markdown
---
allowed-tools: Bash(git status:*)   # optional; tools it may use without asking
argument-hint: [arg]                # optional; shown in autocomplete
description: What the command does.
---

The prompt. $ARGUMENTS is replaced with what you type after the command.
Lines like !`git status` run the command and insert its output.
```

No change to `home.nix` is needed. To remove a command, delete its file.

## Hooks

[Hooks](https://docs.claude.com/en/docs/claude-code/hooks) are scripts Claude Code runs automatically at fixed points, such as before or after a tool call.
Unlike instructions in `CLAUDE.md`, they run every time.

`hooks/` is installed with `programs.claude-code.hooksDir`.
Installing a script doesn't run it: each hook must also be registered for an event under `programs.claude-code.settings.hooks` in [`settings.nix`](settings.nix).
The `claudeHook` helper there builds the entry and puts `jq` on the hook's `PATH`.

| Hook | Event | What it does |
|---|---|---|
| `block-dangerous-commands.sh` | `PreToolUse` on `Bash` | Blocks recursive `rm` of `/`, `~`, `.`, `..` or `*`; force push (`--force-with-lease` is allowed); `git reset --hard`; `git clean -f`; piping `curl` or `wget` into a shell; `dd`, `mkfs`, `wipefs` and `shred` on disks; and `chmod -R 777` |
| `protect-sensitive-files.sh` | `PreToolUse` on `Read`, `Edit`, `MultiEdit`, `Write`, `NotebookEdit` | Blocks reading or writing secrets (`.env*` except examples, keys, `~/.ssh` private keys, `~/.gnupg`, cloud credentials, agenix secrets). Blocks hand edits to lock files and `.git/` |
| `format-on-edit.sh` | `PostToolUse` on `Edit`, `MultiEdit`, `Write` | Formats the edited file, but only with a formatter the project is set up for: `gofmt`, `cargo fmt`, `nix fmt` (if the flake has a `formatter`), `ruff` or `black` (if configured), or the project's own `prettier` |

A hook reads the event as JSON on stdin.
Exit code 2 blocks the action and sends the hook's stderr to Claude as the reason.
`format-on-edit.sh` always exits 0, so a formatter problem never fails an edit.

The blocking hooks match command text and file paths, so they're a safety net, not a sandbox.
For example, `protect-sensitive-files.sh` doesn't stop `cat .env` through `Bash`.

### Adding a hook

1. Create an executable script in `hooks/`, then `chmod +x` it. Git records the executable bit and Nix keeps it.
2. Register it in [`settings.nix`](settings.nix):

   ```nix
   hooks = {
     # ...
     Stop = [
       {hooks = [(claudeHook "my-hook.sh")];}
     ];
   };
   ```

Events include `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `Stop`, `SubagentStop`, `Notification`, `SessionStart`, `SessionEnd` and `PreCompact`.
Tool events take a `matcher`, a regex on the tool name.

## Output styles

[Output styles](https://docs.claude.com/en/docs/claude-code/output-styles) change how Claude responds: its tone, length and format.
They're installed from `output-styles/` through `programs.claude-code.outputStyles`.
There's no `outputStylesDir` option, so [`output-styles.nix`](output-styles.nix) reads the directory and installs every file in it.

| Style | Use it for |
|---|---|
| `Concise` | Short, result-first answers with minimal prose |
| `Code Only` | Changes with almost no commentary |
| `Pair Programmer` | Explaining decisions and trade-offs, and checking in before large or risky changes |

Pick a style with `/config` inside Claude Code.
To make one the default everywhere, set `programs.claude-code.settings.outputStyle = "Concise";`.

To add a style, create `output-styles/<name>.md`:

```markdown
---
name: My Style
description: Shown when picking a style.
keep-coding-instructions: true   # keep Claude Code's software engineering instructions
---

How Claude should respond.
```

## Skills

[Skills](https://docs.claude.com/en/docs/claude-code/skills) are folders of instructions, and optionally scripts or reference files, that Claude loads only when a task needs them.
Claude sees each skill's `name` and `description` up front, then reads the full `SKILL.md` when a task matches the description.
Unlike `CLAUDE.md`, they cost no context until they're used.

`skills/` is installed with `programs.claude-code.skills = ./claude/skills;`.
Home Manager links each file separately, so skills Claude Code manages itself in `~/.claude/skills/` (such as `synced/`) are left alone.

| Skill | Used when |
|---|---|
| `api-design` | Adding or changing HTTP/REST endpoints: naming, status codes, errors, pagination, versioning |
| `database-migrations` | Writing schema or data migrations: expand and contract, locking, batching, rollbacks |
| `shell-scripting` | Writing Bash scripts: strict mode, quoting, cleanup, argument parsing, ShellCheck |

### Adding a skill

Create `skills/<name>/SKILL.md`:

```markdown
---
name: my-skill
description: What the skill covers and when to use it. Claude picks skills from this line, so make it specific.
---

Instructions Claude follows when the skill is used.
```

A skill folder can also hold scripts, templates or reference docs. Mention them in `SKILL.md` so Claude knows to use them.

## MCP servers

[MCP servers](https://docs.claude.com/en/docs/claude-code/mcp) give Claude extra tools.
They're defined in `programs.claude-code.mcpServers` in [`mcp-servers.nix`](mcp-servers.nix), using packages from nixpkgs, so nothing is fetched with `npx` at runtime.
Home Manager passes them to Claude Code through a plugin in the `claude` wrapper, not through `~/.claude.json`.

| Server | What it gives Claude |
|---|---|
| `nixos` | Search NixOS packages, NixOS and Home Manager options, and flake inputs |
| `playwright` | A headless Chromium browser for testing and reading web pages |
| `github` | Issues, pull requests, code search and Actions through the GitHub API. Needs `../secrets/github-token.age` |

Run `/mcp` inside Claude Code to see the servers and their status.

### Creating the GitHub token

The server reads a GitHub personal access token from an agenix secret when it starts, so the token never ends up in the Nix store.

1. Create a [fine-grained token](https://github.com/settings/personal-access-tokens) with access to the repositories and permissions you want Claude to have.
2. Encrypt it from `hosts/vm/secrets/`. `github-token.age` is already listed in `agenix-rules.nix`:

   ```sh
   cd hosts/vm/secrets
   nix run github:ryantm/agenix -- -e github-token.age -i ~/.ssh/secrets-key
   ```

3. `git add` the new file and apply. The build fails until this file exists.

## Applying changes

Flakes only see files tracked by git, so stage new files first. Then apply from the repo root:

```sh
git add hosts/vm/claude
nix run .#home
```

Restart Claude Code to pick up new or changed agents and commands.
Installed files are read-only links into the Nix store, so edit them here, not through `/agents`.
That includes `~/.claude/settings.json`, so settings changed inside Claude Code (for example with `/config` or `/model`) can't be saved.
Set them in `programs.claude-code.settings` instead.

## Tips

- Keep reviewers and auditors read-only (no `Edit`, `Write` or `Bash`), so they report problems instead of changing code.
- Use `model: haiku` for small, frequent tasks to save cost.
- Each agent starts with a fresh context.
  Write prompts that say what to check and what to report, without relying on the main conversation.
