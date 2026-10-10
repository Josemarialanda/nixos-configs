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
| `nix run .#switch`      | `nixos-rebuild switch`            |
| `nix run .#boot`        | `nixos-rebuild boot`              |
| `nix run .#test`        | `nixos-rebuild test`              |
| `nix run .#dry-build`   | `nixos-rebuild dry-build`         |
| `nix run .#home`        | `home-manager switch`             |
| `nix run .#home-build`  | `home-manager build`              |

Extra arguments are passed through, e.g. `nix run .#switch -- --show-trace`.
Format with `nix fmt` (alejandra).

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
