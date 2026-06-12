function fish_mode_prompt --description 'Show vi mode only outside insert'
    if test "$fish_bind_mode" = default
        set_color --bold red
        printf '[N] '
        set_color normal
    end
end
