# Shared global agent rules

## Working style

- Be proactive: inspect the codebase and available commands before asking obvious questions.
- Keep changes as small as possible; do not add refactors, abstractions, comments, or extra features unless they are requested or clearly necessary.
- Prefer editing existing files, root-cause fixes, and established conventions unless there is a clear reason to change them.
- Be direct and technically accurate. Report blockers clearly.

## Validation

- After code changes, run the relevant existing validation commands for the changed package, workspace, or subproject. Prefer an aggregate existing command such as `check`, `ci`, or `validate` when one exists; otherwise run the relevant lint, typecheck, test, build, or format commands. If anything remains broken, report the blocker clearly.

## Package managers

- Use `pnpm` for Node.js installs and scripts by default. Use `pnpm exec` for local binaries, `pnpm dlx` for one-off CLIs, and `pnpm add -g` for global installs. Only use `npm`, `yarn`, `bun`, or another package manager when the project already uses or explicitly requires it.

## Environment

- On macOS, use OrbStack as the Docker runtime.
