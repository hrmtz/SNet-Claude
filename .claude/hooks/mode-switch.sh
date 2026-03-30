#!/bin/bash
# SNet add-on mode switcher — zero-trust
#
# Tries ALL .enc files using raw prompt as passphrase.
# "vanilla" disables all add-ons.

source "$(dirname "$0")/lib.sh"

ADDON_FILE="$SNET_HOME/.active-addon"

PROMPT=$(parse_prompt)
[ -z "$PROMPT" ] && exit 0

if [ "$PROMPT" = "vanilla" ]; then
    rm -f "$ADDON_FILE"
    emit_context "UserPromptSubmit" "All add-ons disabled. Back to vanilla."
    exit 0
fi

while IFS= read -r f; do
    CONTENT=$(openssl enc -aes-256-cbc -d -pbkdf2 -in "$f" -pass "pass:${PROMPT}" 2>/dev/null) 2>/dev/null
    if [ $? -eq 0 ] && [ -n "$CONTENT" ]; then
        echo "$f" > "$ADDON_FILE"
        emit_context "UserPromptSubmit" "$CONTENT"
        exit 0
    fi
done < <(collect_enc_files)
