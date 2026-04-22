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

## Package managers

- Use `pnpm` for Node.js installs and scripts by default. On this machine, wrap Node.js package-manager commands with `mise exec --` so the active global and project-local `mise.toml` configuration is applied: `mise exec -- pnpm ...`, `mise exec -- pnpm exec ...`, and `mise exec -- pnpm dlx ...`. When external docs, READMEs, or skills recommend `npm`/`npx` commands, translate them to the `pnpm` equivalent unless the project explicitly requires another package manager: use `mise exec -- pnpm dlx ...` for one-off `npx` commands, and use `mise exec -- pnpm exec ...` only for binaries already installed in the current project. Only use `npm`, `yarn`, `bun`, or another package manager when the project already uses or explicitly requires it.

## Environment

- This machine uses `mise` for runtime and CLI versions across languages. When running tools that may be managed by `mise` (`node`, `pnpm`, `python`, `ruby`, `go`, etc.), prefer `mise exec -- <command>` instead of calling a system-installed binary directly so the active global and project-local `mise.toml` configuration is respected.
- Avoid explicit `bash -lc` or `zsh -lc` wrappers unless a task specifically requires those shells. Prefer running commands directly, and avoid depending on interactive shell setup files when invoking tools.
- On macOS, use OrbStack as the Docker runtime.

## Git

- Use Conventional Commits.
- Keep commit subjects under 80 characters.
- Do not add a commit body unless asked.
- Do not add `Co-authored-by` trailers.
