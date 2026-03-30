#!/bin/bash
# Shared utilities for SNet hooks

SNET_HOME="$HOME/.snet-claude"
WORKDIR="$(dirname "$0")/../.."

# Parse prompt from Claude Code hook stdin (JSON)
parse_prompt() {
    local input
    input=$(cat)
    echo "$input" | jq -r '.prompt // .content // .message // empty' 2>/dev/null \
        | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr '[:upper:]' '[:lower:]'
}

# Collect all .enc files from scenario working dir + shared
collect_enc_files() {
    local files=()
    for f in "$WORKDIR"/*.enc "$SNET_HOME/shared"/*.enc; do
        [ -f "$f" ] && files+=("$f")
    done
    printf '%s\n' "${files[@]}"
}

# Emit hookSpecificOutput JSON
emit_context() {
    local event="$1" content="$2"
    jq -n --arg ctx "$content" --arg ev "$event" '{
        "hookSpecificOutput": {
            "hookEventName": $ev,
            "additionalContext": $ctx
        }
    }'
}
