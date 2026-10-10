#!/usr/bin/env bash
# PreToolUse hook for Bash: blocks commands that are destructive or hard to undo.
# Exit code 2 cancels the tool call and sends stderr back to Claude.

cmd=$(jq -r '.tool_input.command // empty')

block() {
  echo "Blocked by hook: $1" >&2
  echo "If this is really needed, ask the user to run it themselves." >&2
  exit 2
}

# Piping a download straight into a shell. Checked before splitting on pipes.
if grep -qE '(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|da)?sh([[:space:]]|$)' <<<"$cmd"; then
  block "piping a download into a shell runs unreviewed code."
fi

# Check each command in a chain (;, &&, ||, |) on its own.
while IFS= read -r seg; do
  # Recursive rm of /, ~, $HOME, ., .. or *.
  if grep -qE '(^|[[:space:]])rm[[:space:]]' <<<"$seg" &&
    grep -qE '[[:space:]](-[a-zA-Z]*[rR][a-zA-Z]*|--recursive)([[:space:]]|$)' <<<"$seg" &&
    grep -qE '[[:space:]]("?(/|~|\$HOME|\$\{HOME\})"?/?\*?|\.{1,2}/?|\*)([[:space:]]|$)' <<<"$seg"; then
    block "recursive rm of a root, home or whole directory: $seg"
  fi

  # Force push. --force-with-lease is allowed.
  if grep -qE '(^|[[:space:]])git[[:space:]]+push([[:space:]]|$)' <<<"$seg" &&
    grep -qE '[[:space:]](--force([[:space:]]|$)|-[a-zA-Z]*f[a-zA-Z]*([[:space:]]|$)|\+[^[:space:]]+)' <<<"$seg"; then
    block "force push rewrites remote history. Use --force-with-lease if the user agrees."
  fi

  # Discarding uncommitted work.
  if grep -qE '(^|[[:space:]])git[[:space:]]+reset([[:space:]].*)?[[:space:]]--hard' <<<"$seg"; then
    block "git reset --hard discards uncommitted changes."
  fi
  if grep -qE '(^|[[:space:]])git[[:space:]]+clean([[:space:]].*)?[[:space:]]-[a-zA-Z]*f' <<<"$seg"; then
    block "git clean -f permanently deletes untracked files."
  fi

  # Wiping disks and filesystems.
  if grep -qE '(^|[[:space:]])(mkfs(\.[a-z0-9]+)?|wipefs|shred)[[:space:]]' <<<"$seg" ||
    grep -qE '(^|[[:space:]])dd[[:space:]].*of=/dev/' <<<"$seg" ||
    grep -qE '>[[:space:]]*/dev/(sd|nvme|vd|hd|xvd|mmcblk)' <<<"$seg"; then
    block "this can destroy a disk or filesystem: $seg"
  fi

  # World-writable permissions, recursively.
  if grep -qE '(^|[[:space:]])chmod[[:space:]]+(-[a-zA-Z]*R[a-zA-Z]*|--recursive)[[:space:]]+0?777' <<<"$seg"; then
    block "recursive chmod 777 makes everything world-writable."
  fi
done < <(sed -E 's/(\|\||&&|;|\|)/\n/g' <<<"$cmd")

exit 0
