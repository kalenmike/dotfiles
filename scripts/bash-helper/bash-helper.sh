#!/usr/bin/env bash

# Read the user input from the first argument
USER_INPUT="$1"

# Call Ollama API via curl
# We use -s for silent mode and jq to parse the JSON response
RESPONSE=$(curl -s http://localhost:11434/api/generate -d "{
  \"model\": \"mistral-nemo:12b\",
  \"prompt\": \"System: You are a translator that turns natural language into a single line of bash code. Output ONLY the code. No markdown, no commentary. User: $USER_INPUT\",
  \"stream\": false
}")

# Extract the 'response' field from the JSON and clean up any backticks
echo "$RESPONSE" | jq -r '.response' | tr -d '`' | xargs
