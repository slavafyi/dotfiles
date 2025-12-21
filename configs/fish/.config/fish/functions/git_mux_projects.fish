function git_mux_projects --description "List git repos under a dir"
    set -l root $argv[1]

    if not set -q root; or not test -d "$root"; or not type -q fd
        return
    end

    set -l git_paths (fd --hidden --type d --type f --max-depth 7 --prune --regex .git\$ "$root")
    if test (count $git_paths) -eq 0
        return
    end

    path dirname $git_paths
end
