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

- For commits that change only files under `configs/` or `scripts/`, use the
  corresponding top-level directory as the Conventional Commit scope. Omit the
  scope when a commit spans both or other top-level areas; do not invent a
  generic scope
- When exactly one first-level component or platform is affected, start the
  subject with its name, followed by what changed: `docs(configs): agents ...`
  or `feat(scripts): macos ...`. Use `common` for shared scripts
- When multiple components or platforms are affected, start directly with what
  changed instead of listing them all

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
