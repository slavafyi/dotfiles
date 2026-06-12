function s --description "Display compact status"
    set_color brblack
    printf "%-5s" cwd
    set_color $fish_color_cwd
    printf "%s" (prompt_pwd --dir-length=0)
    set_color normal
    printf "\n"

    set_color brblack
    printf "%-5s" host
    set_color yellow
    printf "%s" $USER
    set_color normal
    printf " at "
    set_color brmagenta
    printf "%s" (prompt_hostname)
    set_color normal
    printf "\n"

    set -l git_prompt (fish_git_prompt '%s')

    if test -n "$git_prompt"
        set_color brblack
        printf "%-5s" git
        set_color normal
        printf "%s\n" $git_prompt
    end

    if set -q VIRTUAL_ENV
        set_color brblack
        printf "%-5s" venv
        set_color brcyan
        printf "%s" (basename "$VIRTUAL_ENV")
        set_color normal
        printf "\n"
    end

    if set -q ZMX_SESSION
        set_color brblack
        printf "%-5s" zmx
        set_color brwhite
        printf "%s" $ZMX_SESSION
        set_color normal
        printf "\n"
    end

end
