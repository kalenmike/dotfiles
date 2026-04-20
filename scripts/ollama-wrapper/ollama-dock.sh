#!/usr/bin/env bash

# Configuration
MODEL="mistral-nemo:12b"
HIST_FILE="/tmp/rofi_ollama_state.json"

if ! curl -s http://localhost:11434/api/ps | jq -e ".models[] | select(.name | contains(\"$MODEL\"))" >/dev/null; then
    # 2. Model is NOT found (Cold), so we wake it up in the background
    curl -s http://localhost:11434/api/generate -d "{\"model\": \"$MODEL\"}" >/dev/null &
    STATUS="[Cold ❄️]"
else
    # 3. Model IS found (Warm)
    STATUS="[Warm 🔥]"
fi

# Initialize history if it doesn't exist
if [ ! -f "$HIST_FILE" ]; then
    echo '[]' >"$HIST_FILE"
fi

# Rofi calls the script with the user's input as the first argument ($1)
USER_INPUT=$1

if [ -n "$USER_INPUT" ]; then
    # 1. Append user message to history
    # (Using jq to handle JSON safely)
    jq --arg msg "$USER_INPUT" '. += [{"role": "user", "content": $msg}]' "$HIST_FILE" >"${HIST_FILE}.tmp" && mv "${HIST_FILE}.tmp" "$HIST_FILE"

    # 2. Call Ollama (Chat API)
    RESPONSE=$(curl -s http://localhost:11434/api/chat -d "{
        \"model\": \"$MODEL\",
        \"messages\": $(cat "$HIST_FILE"),
        \"stream\": false
    }")

    # 3. Extract assistant message and append to history
    ASSISTANT_MSG=$(echo "$RESPONSE" | jq -r '.message.content')
    jq --arg msg "$ASSISTANT_MSG" '. += [{"role": "assistant", "content": $msg}]' "$HIST_FILE" >"${HIST_FILE}.tmp" && mv "${HIST_FILE}.tmp" "$HIST_FILE"

    # 4. Update the Rofi Message box with the latest response
    echo -en "\0message\x1f<b>AI:</b> $ASSISTANT_MSG\n"
fi

# Keep the filter/input bar clear for the next question
echo -en "\0prompt\x1fAsk Ollama\n"
echo -en "\0no-custom\x1ffalse\n"

# Optional: List previous questions as selectable items
jq -r '.[] | select(.role=="user") | .content' "$HIST_FILE" | tac
