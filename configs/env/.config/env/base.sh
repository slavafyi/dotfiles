export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export GIT_EDITOR="${GIT_EDITOR:-$EDITOR}"
export PAGER="${PAGER:-less}"

export NOTES_DIR="${NOTES_DIR:-$HOME/notes}"
export PI_CONFIG_DIR="${PI_CONFIG_DIR:-$XDG_CONFIG_HOME/pi}"
export PI_CODING_AGENT_DIR="${PI_CODING_AGENT_DIR:-$PI_CONFIG_DIR/agent}"

[ -f "$XDG_CONFIG_HOME/env/local.sh" ] && . "$XDG_CONFIG_HOME/env/local.sh"
