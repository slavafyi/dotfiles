function tasks --description 'Open a picker for uncompleted tasks in daily notes'
    set task_re '^\s*[-*]\s+\[ \]'

    zk list daily/ -s path- -f '{{abs-path}}' -0 --no-pager --quiet |
        xargs -0 sh -c 'pattern=$1; shift; [ "$#" -eq 0 ] || rg -n -- "$pattern" "$@"' sh "$task_re" |
        fzf --delimiter : \
            --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
            --bind "enter:become(nvim --cmd 'cd $NOTES_DIR' +{2} {1})"
end
