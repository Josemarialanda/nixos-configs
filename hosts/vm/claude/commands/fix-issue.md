---
allowed-tools: Bash(gh issue view:*), Bash(git status:*), Bash(git diff:*)
argument-hint: [issue-number]
description: Fix a GitHub issue
---
Fix GitHub issue #$ARGUMENTS.

1. Read the issue with `gh issue view $ARGUMENTS`.
2. Find the code responsible and identify the root cause.
3. Implement the smallest fix that resolves the issue, following the existing code style.
4. Add or update tests that cover the fix, and run them.
5. Summarize the cause, the fix, and how it was verified.
