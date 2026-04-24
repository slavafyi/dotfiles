if not status --is-interactive
    return
end

set -g fish_key_bindings fish_hybrid_key_bindings
set -g fish_sequence_key_delay_ms 200

bind -M insert ctrl-p up-or-search
bind -M insert ctrl-n down-or-search
bind -M insert -m default j,k cancel repaint-mode

set -gx GPG_TTY (tty)

if type -q starship
    starship init fish | source - 2>/dev/null
end

if type -q mise
    mise activate fish | source - 2>/dev/null
    set -gx MISE_FISH_AUTO_ACTIVATE 0
end

if type -q fzf
    fzf --fish | source - 2>/dev/null
    bind shift-tab complete-and-search
    bind -M insert shift-tab complete-and-search
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
end

if type -q orb
    source ~/.orbstack/shell/init2.fish 2>/dev/null || :
end

if type -q zoxide
    zoxide init fish | source - 2>/dev/null
    set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS
end
