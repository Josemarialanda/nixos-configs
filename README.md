# nixos-configs

NixOS and Home Manager configurations, managed as a single flake.

## Layout

```
.
├── flake.nix          # inputs, host list, outputs
├── hosts/
│   └── vm/
│       ├── configuration.nix          # NixOS config for this host
│       ├── hardware-configuration.nix
│       ├── home.nix                   # Home Manager config for this host
│       ├── claude/                    # Claude Code setup (see its README)
│       └── secrets/                   # agenix-encrypted secrets (*.age)
├── modules/
│   ├── nixos/         # shared NixOS modules (boot, networking, users, locale, nix, ssh)
│   └── home/          # shared Home Manager modules (bash, git, direnv, agenix, nix-index)
├── overlays/          # adds pkgs/, nixpkgs overrides and pkgs.unstable
└── pkgs/              # custom packages, built with `nix build .#<name>`
```

## How it fits together

Each host in `flake.nix` produces two configurations: a NixOS system and a standalone Home Manager config.

```
                    flake.nix
                  hosts.vm = { hostname, system, username, ... }
                        │
           ┌────────────┴─────────────┐
           ▼                          ▼
   nixosConfigurations.vm     homeConfigurations."nixos@vm"
           │                          │
           ▼                          ▼
 hosts/vm/configuration.nix    hosts/vm/home.nix
           │                          │
           ▼                    ┌─────┴──────┐
    modules/nixos               ▼            ▼
                          modules/home   hosts/vm/claude
```

The `host` attrset and the flake `inputs` are passed to every module as `specialArgs`,
so shared modules read values like `host.username` instead of hardcoding them.

Home Manager uses `overlays/`, which gives modules access to custom packages and `pkgs.unstable`:

```
nixpkgs (26.05) ──┐
pkgs/ ────────────┼──► overlays ──► pkgs  (pkgs.<custom>, pkgs.unstable.<name>)
nixpkgs-unstable ─┘
```

## Usage

Rebuild shortcuts run against the current hostname and user:

| Command                 | Does                              |
|-------------------------|-----------------------------------|
| `nix run .#switch`      | `nh os switch`                    |
| `nix run .#boot`        | `nh os boot`                      |
| `nix run .#test`        | `nh os test`                      |
| `nix run .#build`       | `nh os build`                     |
| `nix run .#dry-build`   | `nh os build --dry`               |
| `nix run .#home`        | `nh home switch`                  |
| `nix run .#home-build`  | `nh home build`                   |

[nh](https://github.com/nix-community/nh) shows a package diff before activating, and also runs weekly GC.
Extra arguments go to nh, e.g. `nix run .#switch -- --show-trace`.
Format with `nix fmt .` (alejandra).
VS Code tasks for these (build, switch, format, lint, check, update) are in `.vscode/tasks.json`.

## Development

`nix develop` (or direnv, via `.envrc`) gives a shell with nixd, alejandra and deadnix,
and installs a pre-commit hook that runs those two on staged files. `nix flake check` runs them
on the whole repo.

## Secrets

Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) and decrypted by Home Manager
using `~/.ssh/secrets-key`. Recipients are listed in `hosts/<host>/secrets/agenix-rules.nix`.

```
secrets/*.age ──(agenix + ~/.ssh/secrets-key)──► decrypted file (e.g. ~/.ssh/gh-ssh-key)
```

## Adding a host

1. Add an entry to `hosts` in `flake.nix`.
2. Create `hosts/<hostname>/configuration.nix` and `hosts/<hostname>/home.nix`,
   importing `../../modules/nixos` and `../../modules/home` respectively.
