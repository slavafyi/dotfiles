set os (uname)

fish_add_path "$XDG_BIN_HOME"

if test "$os" = Darwin
    set -gx TMPDIR (getconf DARWIN_USER_TEMP_DIR)
end

if test -e /opt/homebrew/bin/brew
    fish_add_path /opt/homebrew/bin
    if type -q ggrep
        fish_add_path /opt/homebrew/opt/grep/libexec/gnubin
    end
end

if path is -r -- "$XDG_DATA_HOME/pnpm"
    set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
    fish_add_path "$PNPM_HOME"
end

if status --is-interactive
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

    if type -q nvim
        set -gx EDITOR nvim
    else if type -q vim
        set -gx EDITOR vim
    else
        set -gx EDITOR vi
    end

    set -gx VISUAL "$EDITOR"
    set -gx GIT_EDITOR "$EDITOR"

    if set -q REMOTE_DEV; and test $REMOTE_DEV -eq 1
        set -gx GIT_MUX_PROJECTS "$HOME/dev $HOME/dotfiles $HOME/share"
        set -gx GIT_MUX_PROJECT_PARENTS "$HOME/dev"
    else
        set -gx GIT_MUX_PROJECTS "$HOME/obsidian/personal"
        set -gx GIT_MUX_PROJECT_PARENTS "$HOME/dev/personal $HOME/dev/nx $HOME/dev/open-source"
    end
end
