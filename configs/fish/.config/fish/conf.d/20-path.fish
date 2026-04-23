fish_add_path "$XDG_BIN_HOME"

if path is -r -- "$XDG_DATA_HOME/pnpm"
    set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
    fish_add_path "$PNPM_HOME"
end
