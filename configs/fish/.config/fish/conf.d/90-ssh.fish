if not set -q SSH_AUTH_SOCK
  eval "$(ssh-agent -c)" 2>/dev/null
  set -Ux SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
  set -Ux SSH_AGENT_PID "$SSH_AGENT_PID"
end

ssh-add ~/.ssh/id_ed25519 2>/dev/null
