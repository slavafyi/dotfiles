# Trust the current project per invocation until --yolo skips the trust prompt
# https://github.com/openai/codex/issues/14345
function codex --description "Run codex with current project trusted"
    set -l project (command git rev-parse --show-toplevel 2>/dev/null; or pwd -P)
    set -l key (printf %s "$project" | jq -Rs .)
    command codex -c "projects={$key={trust_level=\"trusted\"}}" $argv
end
