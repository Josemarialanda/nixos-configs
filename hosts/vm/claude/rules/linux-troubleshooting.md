# Linux troubleshooting

- This system is NixOS. Do not edit files in `/etc` or `/nix/store`, and do not use `nix-env` or `nix profile install`. Change the flake configuration, then apply it with `nh` (`nix run .#switch` or `nix run .#home`).
- To run a tool that is not installed, use `, <command>` (comma) or `nix shell nixpkgs#<package>`.
- Use read-only commands first. Ask before a command that changes the system state, such as a restart of a service.
- Services: start with `systemctl --failed` and `systemctl status <unit>`. Use `systemctl --user` for user units.
- Logs: use `journalctl -u <unit> -b --no-pager -n 50` or `journalctl -p 3 -b --no-pager`. Always set `-n` or `--since`.
- Network: use `ip -br a`, `ip r`, `ss -tlnp`, `resolvectl status` and `nmcli`.
- Disk: use `df -h`, `du -sh <dir>` and `lsblk`. For the Nix store, use `nh clean` to remove old generations.
- Processes and memory: use `ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head` and `free -h`.
- Containers: podman is the container runtime, and `docker` is an alias for it.
