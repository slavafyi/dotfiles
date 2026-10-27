# Trust the current project per invocation until --yolo skips the trust prompt
# https://github.com/openai/codex/issues/14345
function codex --description "Run codex with current project trusted"
    set -l codex_args $argv
    argparse --ignore-unknown 'C/cd=' -- $argv; or return

    set -l directory .
    if set -q _flag_cd
        set directory "$_flag_cd"
    end

    if not test -d "$directory"
        printf 'codex: not a directory: %s\n' "$directory" >&2
        return 1
    end

    set -l project (command git -C "$directory" rev-parse --show-toplevel 2>/dev/null; or path resolve -- "$directory")
    set -l key (printf %s "$project" | jq -Rs .)
    command codex -c "projects={$key={trust_level=\"trusted\"}}" $codex_args
end
