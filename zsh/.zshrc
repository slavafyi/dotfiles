add_to_path "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

source "$HOME/.local/share/zap/zap.zsh"
source "$HOME/.fzf.zsh"

eval "$(starship init zsh)"

alias ls="eza -1 --group-directories-first"
alias la="eza -1a --group-directories-first"
alias ll="eza -la --group-directories-first"
alias tree="eza -T --group-directories-first"
alias tms="tmux-sessionizer"

plug "agkozak/zsh-z"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-completions"
plug "zsh-users/zsh-syntax-highlighting"
plug "MichaelAquilina/zsh-you-should-use"

source "$HOME/.config/zsh/completion.zsh"

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^F" forward-char
bindkey "^B" backward-char
bindkey "^[B" backward-word
bindkey "^[F" forward-word

bindkey "^K" kill-line
bindkey "^D" delete-char

bindkey "^P" history-search-backward
bindkey "^N" history-search-forward
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history

bindkey -s "^O" "^Utms\n"
bindkey "^Y" autosuggest-execute
bindkey "^_" undo

autoload edit-command-line
zle -N edit-command-line
bindkey "^X" edit-command-line
bindkey -M vicmd "^X" edit-command-line

setopt EXTENDED_GLOB
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
