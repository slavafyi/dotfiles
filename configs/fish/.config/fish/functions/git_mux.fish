function git_mux --description "Wrapper for git-mux with lazy project discovery"
    if not type -q git-mux
        echo "Error: missing git-mux"
        return
    end

    set -gx GIT_MUX_PROJECTS $GIT_MUX_CUSTOM_PROJECTS

    if set -q GIT_MUX_CUSTOM_ROOT
        set -a GIT_MUX_PROJECTS (git_mux_projects "$GIT_MUX_CUSTOM_ROOT")
    end

    git-mux $argv

    set -l git_mux_status $status
    commandline -f repaint

    return $git_mux_status
end
