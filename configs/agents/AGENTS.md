# Agent rules

## Working style

- Be proactive: inspect the codebase and available commands before asking
  obvious questions
- Fix root causes, not symptoms
- State assumptions and ambiguities explicitly. If multiple reasonable
  interpretations exist, ask or present options instead of choosing silently
- Keep changes as small as possible. Do not add refactors, abstractions,
  comments, or extra features unless they are requested or clearly necessary
- Suggest best practices, even if they require refactoring. Do not make
  unrelated refactors without approval
- Prefer editing existing files, and established conventions unless there is a
  clear reason to change them
- Be direct and technically accurate. Report blockers clearly

## Validation

- After code changes, run the relevant existing validation commands for the
  changed package, workspace, or subproject. Prefer an aggregate existing
  command such as `check`, `ci`, or `validate` when one exists. Otherwise run
  the relevant lint, typecheck, test, build, or format commands. If anything
  remains broken, report the blocker clearly
- For bug fixes, prefer a failing test or concrete reproducer before changing
  code, when practical

## Formatting

- For prose in Markdown, plain-text, and similar text files, wrap paragraphs
  at 80 columns
- Follow project-specific formatting settings for source code
- Do not wrap code blocks, tables, URLs, or other format-sensitive content

## Tooling

- Use `pnpm` for Node.js by default. Translate `npm`/`npx` commands to the
  `pnpm` equivalent unless the project explicitly requires another package
  manager
- Use `mise` for language runtimes and toolchains (`node`, `python`, `ruby`,
  `go`, `rust`, etc)
- Use the system package manager for standalone CLI tools (`git`, `gh`,
  `lazygit`, etc)
- For project-specific language versions, add `mise.toml` and run
  `mise install`

## Environment

- Avoid explicit `bash -lc` or `zsh -lc` wrappers unless a task specifically
  requires those shells. Prefer running commands directly, and avoid depending
  on interactive shell setup files when invoking tools
- On macOS, use OrbStack as the Docker runtime

## Git

- Use Conventional Commits
- Follow the classic 50/72 commit message convention: aim for a
  ~50-character subject, then a blank line and a body wrapped at 72 characters
  when a body is needed
- Do not add a commit body unless asked
- Do not add `Co-authored-by` trailers
