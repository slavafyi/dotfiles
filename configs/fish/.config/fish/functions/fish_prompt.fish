set -gx VIRTUAL_ENV_DISABLE_PROMPT true

function fish_prompt --description "Set fish prompt"
    if set -q ZMX_SESSION
        set_color --bold brwhite
        printf "[S] "
        set_color normal
    end

    if set -q VIRTUAL_ENV
        printf "[venv] "
    end

    set_color yellow
    printf "%s" $USER
    set_color normal
    printf " at "

    set_color magenta
    echo -n (prompt_hostname)
    set_color normal
    printf " in "

    set_color $fish_color_cwd
    printf "%s" (prompt_pwd)
    set_color normal

    printf "%s" (fish_git_prompt)

    echo
    printf "↪ "
    set_color normal
end
