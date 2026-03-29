fish_add_path "$XDG_BIN_HOME"

if path is -r -- "$XDG_DATA_HOME/pnpm"
    set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
    fish_add_path "$PNPM_HOME"
end

set -gx NOTES_DIR "$HOME/notes"
set -gx DOTFILES "$HOME/dev/personal/dotfiles"
set -gx PI_CONFIG_DIR "$XDG_CONFIG_HOME/pi"
set -gx PI_CODING_AGENT_DIR "$PI_CONFIG_DIR/agent"

if not status --is-interactive
    return
end

set -gx FZF_ALT_C_OPTS "
  --preview 'tree {} | head -200'
  --walker-skip .git,node_modules
"
set -gx FZF_CTRL_R_OPTS "
  --bind 'ctrl-/:change-preview-window(down:10:wrap|)'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | copy)+abort'
  --preview 'echo {}'
"
set -gx FZF_CTRL_T_OPTS "
  --walker-skip .git,node_modules
"
set -gx FZF_DEFAULT_OPTS "
  --style=full
  --bind 'ctrl-/:change-preview-window(right|down|)'
  --color=fg:-1,bg:-1,hl:-1
  --color=fg+:-1,bg+:-1,gutter:8,hl+:3
  --color=info:-1,prompt:15,pointer:15
  --color=marker:15,spinner:15,header:-1
  --cycle
  --height=~75%
  --preview 'bat -n {}'
  --preview-window hidden
  --reverse
"

set -gx GPG_TTY (tty)
set -gx MISE_FISH_AUTO_ACTIVATE 0
set -gx VDPAU_DRIVER radeonsi
set -gx EDITOR nvim
set -gx GIT_EDITOR "$EDITOR"
set -gx VISUAL "$EDITOR"

set -gx GIT_MUX_CUSTOM_ROOT "$HOME/dev"
if set -q REMOTE_DEV; and test $REMOTE_DEV -eq 1
    set -gx GIT_MUX_CUSTOM_PROJECTS "$HOME/dotfiles" "$HOME/share"
else
    set -gx GIT_MUX_CUSTOM_PROJECTS "$NOTES_DIR"
end
