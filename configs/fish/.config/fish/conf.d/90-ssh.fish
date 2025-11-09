if set -q SSH_FORWARDING_ENABLED; and test $SSH_FORWARDING_ENABLED -eq 1
    echo "SSH agent forwarding detected, skipping agent setup"
    exit 0
end

if type -q ssh-agent
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
end
