if path is -r -- "$HOME/.local/share/pnpm"
  set --export PNPM_HOME "$HOME/.local/share/pnpm"
  set --export PATH "$PNPM_HOME" "$PATH"
end

set --export VDPAU_DRIVER radeonsi

if status --is-interactive; and type -q nvim
  set --export EDITOR nvim
end
