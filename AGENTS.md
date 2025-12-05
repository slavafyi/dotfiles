# AGENT GUIDE

1. Build and full setup run via `make install` (wraps `install.sh`)
2. Update only base packages with `make update`
3. Format everything with `make fmt` (runs shfmt, stylua, fish_indent)
4. Shell formatting uses `shfmt --write <paths>` and `.editorconfig` rules
5. Lua formatting uses `stylua --allow-hidden --search-parent-directories .`
6. Fish formatting uses `fish -c 'fish_indent -w configs/fish/.config/**/*.fish'`
7. No global test suite exists; test stages via `./install.sh <function>` (e.g., `./install.sh dev_tools`)
8. New install steps must be idempotent and safe on reruns
9. Bash scripts: `#!/usr/bin/env bash`, `set -euo pipefail`, snake_case, `local`, helpers from `scripts/common/utils.sh`
10. Use `print_in_[color]` from helpers for output, quote expansions, and prefer `[[ ... ]]`
11. Guard privileged actions with `ask_for_sudo`; failures exit via `print_in_red`
12. Fish configs: 4-space indent, gated by `if status --is-interactive`, gate external commands with `type -q`
13. Lua lives under `configs/neovim/.config/nvim/lua` and follows Stylua defaults (2 spaces, col 100, single quotes)
14. Keep Lua declarative (`vim.opt`, `vim.keymap.set`, top-level `require`s only)
15. Flag long Lua blocks with `-- stylua: ignore` instead of disabling formatters
16. New CLI tools belong in `configs/bin/.local/bin`, stay POSIX-friendly, and reuse shared helpers
17. Apply dotfiles only via `stow --dir configs --target "$HOME" --stow <component>`; never handcraft symlinks
18. Keep package lists under `packages/<os>` alphabetized
19. Never commit secrets; store them outside the repo (see `mise/.secrets.yaml`)
