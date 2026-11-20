#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/select-theme.sh"

BASHRC="$HOME/.bashrc"
SNIPPET='# oh-my-posh
if [[ "$TERM" != "linux" ]]; then
    eval "$(oh-my-posh init bash --config ~/Themes/oh-my-posh-themes/powerlevel10k-doineann.omp.json)"
fi'

if grep -q 'oh-my-posh init bash' "$BASHRC"; then
    echo "oh-my-posh is already initialized in $BASHRC — nothing to add."
    exit 0
fi

if [ -s "$BASHRC" ] && [ -n "$(tail -n 1 "$BASHRC")" ]; then
    if [ -n "$(tail -c 1 "$BASHRC")" ]; then
        printf '\n\n' >> "$BASHRC"
    else
        printf '\n' >> "$BASHRC"
    fi
fi
printf '%s\n' "$SNIPPET" >> "$BASHRC"
echo "oh-my-posh bash init added to $BASHRC"
