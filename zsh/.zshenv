function add_to_path() {
  if [[ $PATH != *"$1"* ]]; then
    export PATH=$1:$PATH
  fi
}

export FZF_DEFAULT_OPTS="
  --height=~75%
  --extended
  --cycle
  --border=rounded
  --color=fg:-1,bg:-1,hl:-1
  --color=fg+:-1,bg+:-1,hl+:-1
  --color=info:-1,prompt:-1,pointer:-1
  --color=marker:-1,spinner:-1,header:-1
"

export TMUX_DIRS=(
  ~
  ~/dev
  ~/dev/nx
  ~/dev/personal
  ~/dev/work
  ~/dev/work/medito
  ~/dev/work/medito/apps
  ~/dev/work/medito/themes
  ~/dev/work/medito/storefronts
  ~/dev/work/medito/scripts
  ~/dev/work/steadyfreddy
  ~/dev/work/steadyfreddy/scripts
  ~/dev/work/steadyfreddy/theme
)

export HISTORY_IGNORE="(#i)(*pass*|*secret*|*token*|*key*|*vault*)"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export EDITOR="nvim"
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export DOTFILES="$HOME/.dotfiles"
export ZSH_COMPLETIONS="$HOME/.local/share/completions"
export PNPM_HOME="$HOME/Library/pnpm"
export GPG_TTY="$(tty)"

add_to_path "$PNPM_HOME"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.local/scripts"
