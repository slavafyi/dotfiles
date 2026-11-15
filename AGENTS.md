# AGENT GUIDE

For human-oriented usage and profiles, see `README.md` and
`./install.sh help`. This file is agent/contributor-facing: conventions,
safety rules, and the repo’s source-of-truth commands.

## Commands

- Full installation: `make install` (defaults to profile `full`)
- Install a named profile: `make install PROFILE=minimal-server` (or
  `./install.sh profile minimal-server`)
- List profiles: `./install.sh list-profiles`
- Run an individual module: `./install.sh dev_tools`
- Update base system/packages only: `make update`
- Format repo files: `make fmt`

## Formatting

These commands reflect what `make fmt` runs:

- Shell: `shfmt --write .` (uses `.editorconfig` where applicable; currently
  `shell_variant = bash` for `*.sh`)
- Fish: `fish --command "fish_indent -w configs/fish/.config/**/*.fish"`

## Validation (recommended)

- No global test suite exists; validate changes by re-running the relevant
  stage: `./install.sh <module>`
- Bash: run `bash -n path/to/script.sh` (syntax) and
  `shellcheck path/to/script.sh` when available
- Fish: run `fish -n path/to/script.fish` (syntax)

## Installer rules

- New install steps must be idempotent and safe on reruns
- Guard privileged actions with `ask_for_sudo`
- Use `print_in_[color]` helpers for user-facing output; failures should exit
  via `print_in_red` (helpers in `scripts/common/utils.sh`)
- Keep top-level install module names as `system_base`, `user_core`,
  `desktop_env`, `dev_tools`, and `optional_extras`
- Helper commands exposed via `install.sh` should use `setup_*` names across
  OSes when they represent the same task; keep `update_system` for the OS update
  step

## Bash conventions

- Use `#!/usr/bin/env bash` and `set -euo pipefail`
- Use `snake_case` for functions/variables and prefer `local` inside functions
- Quote expansions, prefer `[[ ... ]]`, and prefer `printf` over `echo`

## Fish conventions

- 4-space indent
- Gate interactive-only behavior with `if status --is-interactive ... end`
- Gate external commands with `type -q`

## Git

- Use separate commits for unrelated changes, including submodule updates.
  Keep changes for the same feature, fix, or migration in one commit, even
  across platforms or when the parts could work independently.
- Use scope `configs` when all changed files are under `configs/`, or `scripts`
  when all are under `scripts/`. Omit the scope for other changes, including
  changes that touch both directories. Do not make up another scope.
- When committing inside a submodule, follow its own commit rules. Do not use
  `configs` or `scripts` just because of where the submodule is stored here.
- Choose the type based on what changed:
  - `feat`: add a capability or setup step.
  - `fix`: correct broken behavior.
  - `refactor`: reorganize code or config without changing behavior.
  - `chore`: routine config maintenance or dependency updates.
- Start the subject with the main tool, component, or platform, followed by
  what changed. This also applies when its changes span several directories
  or platforms: `feat: pnpm add setup`, `chore(configs): neovim update`, or
  `feat(scripts): macos add system preferences`.
- Use `common` for shared scripts when there is no main tool or component.
  For other changes without one main tool, component, or platform, describe
  the change directly instead of listing everything affected.
- Keep the action short. Use "add setup" instead of listing config files,
  symlinks, or platforms. Use a more specific action than "update" when possible.

## Layout rules

- New CLI tools belong in `configs/bin/.local/bin` (POSIX-friendly, reuse
  shared helpers)
- Apply dotfiles only via stow:
  `stow --dir configs --target "$HOME" --stow <component>`
  (never handcraft symlinks)
- Keep package lists under `misc/packages/<os>` alphabetized
- Never commit secrets; store them outside the repo (see `mise/.secrets.yaml`)

## References

- ShellCheck: https://www.shellcheck.net/
- Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html
- EditorConfig spec: https://editorconfig.org/
- GNU Stow manual: https://www.gnu.org/software/stow/manual/stow.html
- fish shell documentation: https://fishshell.com/docs/current/
