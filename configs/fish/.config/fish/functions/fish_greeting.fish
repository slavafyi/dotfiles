function fish_greeting --description "Set fish greeting"
    if type -q zeit
        echo
        set_color brblack
        echo "○ Time tracking status:"
        zeit
        set_color normal
        echo
    end
end
