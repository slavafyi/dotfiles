[ -f "$HOME/.config/env/base.sh" ] && . "$HOME/.config/env/base.sh"
[ -f "$HOME/.config/env/path.sh" ] && . "$HOME/.config/env/path.sh"

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
