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
