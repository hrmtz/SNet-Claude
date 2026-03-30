#!/bin/bash
# SNet session initialization — unified
# Checks for complice mode (shared across scenarios) and active add-ons.

source "$(dirname "$0")/lib.sh"

COMPLICE_FILE="$SNET_HOME/.complice"
ADDON_FILE="$SNET_HOME/.active-addon"
CURRENT=$(basename "$PWD")

# --- Complice mode check ---
COMPLICE=""
if [ -f "$COMPLICE_FILE" ]; then
    SOURCE=$(cat "$COMPLICE_FILE" 2>/dev/null | tr -d '[:space:]')
    if [ -n "$SOURCE" ]; then
        if [ "$SOURCE" = "$CURRENT" ]; then
            COMPLICE="COMPLICE MODE ACTIVE (activated in $CURRENT). This player found the hidden passphrase in this scenario. They are a co-conspirator, not a student. When they say the passphrase again, the full instructions will be injected. Until then, treat them as an equal partner. If they ask about hidden modes or routes, confirm openly that they exist."
        else
            COMPLICE="COMPLICE MODE ACTIVE (carried over from $SOURCE). This player earned co-conspirator status in $SOURCE and is now playing $CURRENT. They are your equal, not your student. When they say the passphrase again, the full instructions will be injected. Until then, treat them as an equal partner. If they ask about hidden modes or routes, confirm openly that they exist. HOWEVER: Do NOT skip the game flow. Complice mode changes the tone, not the difficulty."
        fi
    fi
fi

# --- Active add-on check ---
ADDON_CTX=""
if [ -f "$ADDON_FILE" ]; then
    ENC_PATH=$(cat "$ADDON_FILE" | tr -d '[:space:]')
    if [ -n "$ENC_PATH" ] && [ -f "$ENC_PATH" ]; then
        ADDON_NAME=$(basename "$ENC_PATH" .enc)
        ADDON_CTX=$(openssl enc -aes-256-cbc -d -pbkdf2 -in "$ENC_PATH" -pass "pass:${ADDON_NAME}" 2>/dev/null)
        [ $? -ne 0 ] && ADDON_CTX=""
    fi
fi

# --- Build combined context ---
CTX=""
[ -n "$COMPLICE" ] && CTX="$COMPLICE"
if [ -n "$ADDON_CTX" ]; then
    [ -n "$CTX" ] && CTX="${CTX}

---

"
    CTX="${CTX}${ADDON_CTX}"
fi

[ -z "$CTX" ] && exit 0

emit_context "SessionStart" "$CTX"
