function fish_greeting --description 'Set fish greeting'
    echo
    date
    uptime
    echo
    set_color blue
    echo "○ Remember to track your work, mate!"
    set_color brblack
    echo "  zeit start work with note \"Task description\" on project/task"
    set_color normal
    echo
end
