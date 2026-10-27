# Save project trust without CLI overrides so Codex can use the shared daemon.
# https://github.com/openai/codex/issues/14345
function codex --description "Run codex with current project trusted"
    set -l codex_args $argv
    set -l options $argv
    set -l separator (contains -i -- -- $options)
    if test -n "$separator"
        set -e options[$separator..-1]
    end

    argparse --move-unknown h/help V/version C/cd= c/config= m/model= \
        p/profile= s/sandbox= a/ask-for-approval= i/image= \
        enable= disable= remote= remote-auth-token-env= local-provider= add-dir= \
        -- $options; or return

    if set -q _flag_help; or set -q _flag_version; or contains -- "$argv[1]" \
            exec e review login logout mcp plugin app-server remote-control app completion \
            update doctor sandbox debug apply a queue archive delete unarchive \
            migrate-rollouts migrate-nfs-db cloud exec-server features help
        command codex $codex_args
        return $status
    end

    set -l directory .
    if set -q _flag_cd
        set directory "$_flag_cd"
    end

    if not test -d "$directory"
        printf 'codex: not a directory: %s\n' "$directory" >&2
        return 1
    end

    set -l project (command git -C "$directory" rev-parse --show-toplevel 2>/dev/null; or path resolve -- "$directory")
    set -l rpc_dir (mktemp -d); or return
    if not mkfifo "$rpc_dir/requests" "$rpc_dir/responses"
        rm -r "$rpc_dir"
        return 1
    end

    # Open the pipes in a child process so Fish does not block on redirection.
    sh -c 'exec codex app-server --stdio < "$1/requests" > "$1/responses"' sh "$rpc_dir" &
    set -l server $last_pid

    begin
        jq -nc --arg project "$project" '
            {
                id: 1,
                method: "initialize",
                params: {clientInfo: {name: "codex-fish", version: "1"}}
            },
            {method: "initialized"},
            {
                id: 2,
                method: "config/value/write",
                params: {
                    keyPath: "projects",
                    value: {($project): {trust_level: "trusted"}},
                    mergeStrategy: "upsert"
                }
            }
        '
        jq -ne '
            first(inputs | select(.id == 2 or (.id == 1 and has("error"))))
            | .result.status == "ok"
        ' <"$rpc_dir/responses" >/dev/null
    end >"$rpc_dir/requests"
    or printf 'codex: could not trust %s\n' "$project" >&2

    wait $server
    rm -r "$rpc_dir"
    command codex $codex_args
end
