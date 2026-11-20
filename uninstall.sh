#!/bin/bash

BASHRC="$HOME/.bashrc"

if ! grep -q 'oh-my-posh init bash' "$BASHRC"; then
    echo "oh-my-posh is not installed in $BASHRC — nothing to remove."
    exit 0
fi

sed -i '/^# oh-my-posh$/,/^fi$/d' "$BASHRC"
sed -i -e :a -e '/^[[:space:]]*$/{$d;N;ba' -e '}' "$BASHRC"
echo "oh-my-posh bash init removed from $BASHRC"
