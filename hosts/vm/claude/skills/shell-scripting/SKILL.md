---
name: shell-scripting
description: Conventions for writing robust, safe Bash scripts, covering strict mode, quoting, error handling, temporary files, argument parsing and ShellCheck. Use when writing, editing or reviewing shell scripts, or when a task needs more than a one-line shell command.
---

# Shell scripting

Follow the project's existing script style first. Use these conventions where it has none.

## Start every script like this

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `-e` exits on the first failing command.
- `-u` makes unset variables an error.
- `-o pipefail` makes a pipeline fail if any command in it fails, not just the last.

Use `#!/bin/sh` and POSIX syntax only if the script must run where Bash isn't available.

## Quoting

- Always quote variable expansions: `"$file"`, `"${files[@]}"`, `"$(command)"`. Unquoted variables split on spaces and expand globs.
- Use arrays for lists, especially lists of arguments: `args=(--verbose "$input")`, then `cmd "${args[@]}"`.
- Use `[[ ... ]]` for tests in Bash. It's safer than `[ ... ]`.
- Use `$(...)`, not backticks.

## Errors and cleanup

- Print errors to stderr and exit non-zero:

  ```bash
  die() { echo "error: $*" >&2; exit 1; }
  [[ -f $config ]] || die "config not found: $config"
  ```

- Create temporary files and directories with `mktemp`, and remove them with a trap:

  ```bash
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  ```

- Commands that are allowed to fail need an explicit `|| true`, or an `if`, so `set -e` doesn't stop the script.
- Check that required tools exist up front: `command -v jq >/dev/null || die "jq is required"`.

## Variables and functions

- Use `local` for variables inside functions.
- Use lowercase names for script variables. Keep UPPERCASE for exported environment variables.
- Give defaults with `${VAR:-default}`, and require a value with `${VAR:?VAR must be set}`.
- Put the main logic in a `main` function called at the end with `main "$@"`, so the whole file is parsed before anything runs.

## Arguments

- Print usage with `-h` or `--help`, and on invalid arguments.
- For a few options, a `while`/`case` loop over `"$@"` is clearest:

  ```bash
  while [[ $# -gt 0 ]]; do
    case $1 in
      -v | --verbose) verbose=1; shift ;;
      -o | --output) output=$2; shift 2 ;;
      -h | --help) usage; exit 0 ;;
      --) shift; break ;;
      -*) die "unknown option: $1" ;;
      *) break ;;
    esac
  done
  ```

## Safety

- Use `--` before paths that could start with `-`: `rm -- "$file"`.
- Guard destructive commands against empty variables: `rm -rf "${dir:?}/"`.
- Don't parse `ls` output. Use globs or `find ... -print0 | xargs -0`.
- Read lines with `while IFS= read -r line; do ...; done < file`.
- Never `eval` untrusted input.

## Before finishing

- Run `shellcheck` on the script if it's available, and fix what it reports.
- Make the script executable with `chmod +x`.
- If a script grows past about 100 lines or needs complex data structures, suggest rewriting it in a general-purpose language such as Python.
