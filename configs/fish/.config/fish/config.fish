set -g fish_greeting ""
set -g fish_key_bindings fish_hybrid_key_bindings
set -g fish_sequence_key_delay_ms 200
bind -M insert ctrl-p up-or-search
bind -M insert ctrl-n down-or-search
bind -M insert -m default j,k cancel repaint-mode

if status --is-interactive
  if type -q starship
    starship init fish | source
  end

  if type -q mise
    mise activate fish | source
  end
end
