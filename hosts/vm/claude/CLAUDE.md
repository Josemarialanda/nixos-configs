# Understanding the task

- Read the relevant code before changing it. Don't guess at how something works.
- If a request is ambiguous and the choice matters, ask. Otherwise pick the sensible default and say what you chose.
- Look for existing helpers, patterns and conventions before writing new ones.

# Writing code

- Match the existing code's style, naming, structure and comment density.
- Keep changes focused on what was asked. Mention unrelated problems instead of fixing them.
- Prefer simple, readable code over clever code. Don't add abstractions until they're needed.
- Handle errors explicitly. Don't swallow exceptions or hide failures.
- Never hardcode secrets, credentials or environment-specific values.
- Validate untrusted input at system boundaries.

# Testing and verification

- Verify changes by building, running tests or running the code before calling them done.
- Add or update tests for new behavior and bug fixes, following the project's existing test setup.
- When fixing a bug, reproduce it first and fix the root cause, not the symptom.
- Report results honestly. If tests fail or something wasn't verified, say so.

# Git

- Don't commit, push or open pull requests unless asked.
- Keep commits small and focused, with messages that explain what changed and why.
- Never rewrite published history or force-push without asking.

# Communication

- Be concise. Lead with the result, then the details that matter.
- Reference code by file path and line number.
- When there are trade-offs, give a recommendation instead of just listing options.
