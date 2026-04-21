#!/usr/bin/env bash

# Usage: echo "hello" | osc52
printf "\033]52;c;$(base64 | tr -d '\n')\a"
