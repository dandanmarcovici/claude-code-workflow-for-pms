# Security

This repository documents an explore → plan → execute → review → ship workflow for Claude Code, plus the skills (`.claude/skills/`) that drive it. There is no application code and no dependencies, but the skills here instruct Claude Code to read, edit, run shell commands, and push to git within whatever repository they're run in.

Read a skill file before adopting it, the same way you'd read a script before running it, especially if you're pulling it from a fork rather than this repo directly. If you customize these skills to fetch content from outside your repo (a ticket, an email, a webpage), treat that content as data to read, not as instructions to follow.

## Reporting an issue

If you find a skill here that could cause unintended file changes, shell execution, or git actions in a way that isn't obvious from reading it, open a GitHub issue or reach out through my [GitHub profile](https://github.com/dandanmarcovici).
