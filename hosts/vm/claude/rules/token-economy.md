# Token economy

- Read only the lines that you need. For a large file, find the lines with `rg -n` first, then read that range.
- Do not read a file again after you edit it, unless the edit failed.
- Limit command output. Use `--stat`, `--oneline`, `-q`, `rg -l`, `head` and `tail`, and filter logs with `rg`.
- Use `git diff -- <path>` for one file, not the full diff.
- Do not read generated files, lock files, build output or vendored code, unless the task is about them.
- Put independent tool calls in one turn.
- Give a large or noisy task, such as a build log, to a subagent that returns only the result.
- Do not repeat file contents or command output in replies. Give a file path and line number.
