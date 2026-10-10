#!/usr/bin/env bash
# PostToolUse hook for file edits: formats the edited file with the project's formatter.
# Only runs a formatter the project is set up for and that is on PATH, so it never
# reformats files in a style the project doesn't use. Never fails the edit.

path=$(jq -r '.tool_input.file_path // empty')
[[ -f $path ]] || exit 0

has() { command -v "$1" >/dev/null 2>&1; }

# Prints the nearest ancestor directory of the file that contains any of the given files.
find_up() {
  local dir
  dir=$(dirname "$path")
  while :; do
    for f in "$@"; do
      if [[ -e $dir/$f ]]; then
        echo "$dir"
        return 0
      fi
    done
    [[ $dir == / ]] && return 1
    dir=$(dirname "$dir")
  done
}

case "$path" in
  *.go)
    has gofmt && gofmt -w "$path"
    ;;
  *.rs)
    root=$(find_up Cargo.toml) && has cargo && (cd "$root" && cargo fmt -- "$path")
    ;;
  *.nix)
    root=$(find_up flake.nix) && grep -q 'formatter' "$root/flake.nix" &&
      (cd "$root" && timeout 60 nix fmt -- "$path")
    ;;
  *.py)
    if root=$(find_up ruff.toml .ruff.toml) || { root=$(find_up pyproject.toml) && grep -q '^\[tool\.ruff' "$root/pyproject.toml"; }; then
      has ruff && ruff format --quiet "$path"
    elif root=$(find_up pyproject.toml) && grep -q '^\[tool\.black\]' "$root/pyproject.toml"; then
      has black && black --quiet "$path"
    fi
    ;;
  *.js | *.jsx | *.mjs | *.cjs | *.ts | *.tsx | *.json | *.css | *.scss | *.html | *.vue | *.svelte | *.md | *.yaml | *.yml)
    root=$(find_up .prettierrc .prettierrc.json .prettierrc.yaml .prettierrc.yml .prettierrc.js .prettierrc.cjs \
      .prettierrc.mjs .prettierrc.toml prettier.config.js prettier.config.cjs prettier.config.mjs) &&
      [[ -x $root/node_modules/.bin/prettier ]] && "$root/node_modules/.bin/prettier" --write --log-level warn "$path"
    ;;
esac >/dev/null 2>&1

exit 0
