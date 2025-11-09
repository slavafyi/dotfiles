function __tmux_update_ssh_auth_sock --on-event fish_preexec
    if set -q TMUX
        set -l new_sock (string replace --regex "^SSH_AUTH_SOCK=" "" \
                  (tmux show-environment SSH_AUTH_SOCK))
        if test "$new_sock" != "$SSH_AUTH_SOCK"
            set -gx SSH_AUTH_SOCK "$new_sock"
        end
    end
end

if set -q SSH_FORWARDING_ENABLED; and test $SSH_FORWARDING_ENABLED -eq 1
    exit 0
end

if type -q ssh-agent
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
end
