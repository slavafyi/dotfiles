if test -e "/opt/homebrew/bin/brew"
  fish_add_path "/opt/homebrew/bin"
end

if path is -r -- "$HOME/.local/share/pnpm"
  set -gx PNPM_HOME "$HOME/.local/share/pnpm"
  fish_add_path "$PNPM_HOME"
end

if status --is-interactive
  set -gx GPG_TTY (tty)
  set -gx MISE_FISH_AUTO_ACTIVATE 0
  set -gx VDPAU_DRIVER radeonsi

  if type -q nvim
    set -gx EDITOR nvim
  else
    set -gx EDITOR vim
  end

  set -gx VISUAL "$EDITOR"
  set -gx GIT_EDITOR "$EDITOR"
end
