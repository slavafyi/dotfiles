if type -q ssh-agent
  if type -q pgrep
    if not pgrep -u "$USER" ssh-agent > /dev/null
      rm -v "$SSH_AGENT_SOCK"
    end
  end

  if not test -S SSH_AUTH_SOCK
    eval "$(ssh-agent -c)" > /dev/null
    set -Ux SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
    set -Ux SSH_AGENT_PID "$SSH_AGENT_PID"
  end

  ssh-add ~/.ssh/id_ed25519 2> /dev/null
end
