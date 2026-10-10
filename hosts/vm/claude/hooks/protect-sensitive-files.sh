#!/usr/bin/env bash
# PreToolUse hook for file tools: keeps Claude out of secrets, and stops hand edits
# to lock files and git internals.
# Exit code 2 cancels the tool call and sends stderr back to Claude.

input=$(cat)
tool=$(jq -r '.tool_name // empty' <<<"$input")
path=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' <<<"$input")
[[ -z $path ]] && exit 0
name=$(basename "$path")

block() {
  echo "Blocked by hook: $1" >&2
  exit 2
}

# Secrets: no reading or writing.
case "$name" in
  .env.example | .env.sample | .env.template) ;;
  .env | .env.* | *.pem | *.key | *.p12 | *.pfx | id_rsa | id_dsa | id_ecdsa | id_ed25519 | .netrc | .pgpass)
    block "$path may contain secrets. Ask the user for the values you need." ;;
esac
case "$path" in
  */.ssh/*.pub | */.ssh/config | */.ssh/known_hosts*) ;;
  */.ssh/* | */.gnupg/* | */.aws/credentials | */.docker/config.json | /run/agenix* | /run/user/*/agenix*)
    block "$path may contain secrets. Ask the user for the values you need." ;;
esac

# Everything below only applies to writes.
[[ $tool == Read ]] && exit 0

case "$name" in
  package-lock.json | yarn.lock | pnpm-lock.yaml | bun.lock | bun.lockb | Cargo.lock | poetry.lock | uv.lock | \
    Pipfile.lock | Gemfile.lock | composer.lock | go.sum | flake.lock)
    block "$name is generated. Update it with the package manager instead of editing it." ;;
esac
case "$path" in
  */.git/*) block "don't edit git internals directly. Use git commands." ;;
esac

exit 0
