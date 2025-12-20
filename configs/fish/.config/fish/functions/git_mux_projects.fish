function git_mux_projects --description "List git repos under a dir"
    set -l root $argv[1]

    if test -z "$root"
        return
    end

    if not test -d "$root"
        return
    end

    if not type -q fd
        return
    end

    set -l git_paths (fd --hidden --type d --max-depth 5 --prune --regex '\.git$' "$root")
    if test (count $git_paths) -eq 0
        return
    end

    set -l projects
    for git_path in $git_paths
        set -a projects (path dirname "$git_path")
    end

    printf "%s\n" $projects
end
