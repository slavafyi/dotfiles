path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

path_prepend "$XDG_BIN_HOME"

PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
export PNPM_HOME
path_prepend "$PNPM_HOME"

export PATH
