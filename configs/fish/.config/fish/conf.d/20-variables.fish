set os (uname)

fish_add_path "$HOME/.local/bin"

if test "$os" = Darwin
    set -gx TMPDIR (getconf DARWIN_USER_TEMP_DIR)
end

if test -e /opt/homebrew/bin/brew
    fish_add_path /opt/homebrew/bin
end

if path is -r -- "$XDG_DATA_HOME/pnpm"
    set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
    fish_add_path "$PNPM_HOME"
end

if status --is-interactive
    set -gx FZF_DEFAULT_OPTS "
    --height=~75%
    --extended
    --cycle
    --border=rounded
    --color=fg:-1,bg:-1,hl:-1
    --color=fg+:-1,bg+:-1,hl+:-1
    --color=info:-1,prompt:-1,pointer:-1
    --color=marker:-1,spinner:-1,header:-1
  "
    set -gx GIT_MUX_PROJECTS "$HOME/obsidian/personal"
    set -gx GIT_MUX_PROJECT_PARENTS "$HOME/dev/personal $HOME/dev/nx"
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
end
