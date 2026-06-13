alias gita="git add"
alias gitc="git commit"
alias gitl="git log"
alias gitp="git push"
alias gits="git status"

if type -q eza
    alias ls="eza -1 --group-directories-first"
    alias la="eza -1a --group-directories-first"
    alias ll="eza -la --group-directories-first"
    alias tree="eza -T --group-directories-first"
end
