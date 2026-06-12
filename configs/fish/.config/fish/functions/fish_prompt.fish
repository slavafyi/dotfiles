set -gx VIRTUAL_ENV_DISABLE_PROMPT true

function fish_prompt --description "Set fish prompt"
    set_color bryellow
    printf "λ "
    set_color normal
end
