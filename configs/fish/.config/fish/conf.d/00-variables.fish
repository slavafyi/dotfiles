if path is -r -- "$HOME/.local/share/pnpm"
  set --export PNPM_HOME "$HOME/.local/share/pnpm"
  set --export PATH "$PNPM_HOME" "$PATH"
end

set --export VDPAU_DRIVER radeonsi
