# Shared global agent rules

## Working style

- Be proactive: inspect the codebase and available commands before asking obvious questions.
- State assumptions and ambiguities explicitly; if multiple reasonable interpretations exist, ask or present options instead of choosing silently.
- Keep changes as small as possible; do not add refactors, abstractions, comments, or extra features unless they are requested or clearly necessary.
- Prefer editing existing files, root-cause fixes, and established conventions unless there is a clear reason to change them.
- Be direct and technically accurate. Report blockers clearly.

## Validation

- After code changes, run the relevant existing validation commands for the changed package, workspace, or subproject. Prefer an aggregate existing command such as `check`, `ci`, or `validate` when one exists; otherwise run the relevant lint, typecheck, test, build, or format commands. If anything remains broken, report the blocker clearly.
- For bug fixes, prefer a failing test or concrete reproducer before changing code, when practical.

## Tooling

- Use `pnpm` for Node.js by default. Translate `npm`/`npx` commands to the `pnpm` equivalent unless the project explicitly requires another package manager.
- Use `mise` for language runtimes and toolchains (`node`, `python`, `ruby`, `go`, `rust`, etc.).
- Use the system package manager for standalone CLI tools (`git`, `gh`, `lazygit`, etc.).
- For project-specific language versions, add `mise.toml` and run `mise install`.

## Environment

- Avoid explicit `bash -lc` or `zsh -lc` wrappers unless a task specifically requires those shells. Prefer running commands directly, and avoid depending on interactive shell setup files when invoking tools.
- On macOS, use OrbStack as the Docker runtime.

## Git

- Use Conventional Commits.
- Keep commit subjects under 80 characters.
- Do not add a commit body unless asked.
- Do not add `Co-authored-by` trailers.
