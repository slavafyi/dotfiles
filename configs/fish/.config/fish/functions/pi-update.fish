function pi-update --description "Update pi-agent and extensions"
    command pi update --all; or return

    set -l pi_cli (sed -n 's/^# cmd-shim-target=//p' (command -s pi))
    set -l examples (path dirname "$pi_cli")/../../examples/extensions
    set -l extensions "$PI_CODING_AGENT_DIR/extensions"

    test -f "$examples/handoff.ts"
    and test -f "$examples/notify.ts"
    or return 1

    mkdir -p "$extensions"; or return
    command rsync -a "$examples/handoff.ts" "$examples/notify.ts" "$extensions/"
end
