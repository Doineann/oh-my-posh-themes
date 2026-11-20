#!/bin/bash

THEME_DIR="$HOME/Themes/oh-my-posh-themes"
BASE_THEME="powerlevel10k-doineann.omp.json"

shopt -s nullglob
files=("$THEME_DIR"/powerlevel10k-doineann-*.omp.json)
colors=()
for f in "${files[@]}"; do
  colors+=("$(basename "$f" .omp.json | sed 's/^powerlevel10k-doineann-//')")
done

if [ ${#colors[@]} -eq 0 ]; then
  echo "No powerlevel10k-doineann color themes found in $THEME_DIR" >&2
  exit 1
fi

selected=""

if command -v fzf >/dev/null 2>&1 && [ -t 1 ]; then
  selected=$(printf "%s\n" "${colors[@]}" | fzf --height 10 --reverse)
fi

if [ -z "$selected" ]; then
  PS3="Select a color theme [1-${#colors[@]}]: "
  select choice in "${colors[@]}"; do
    selected="$choice"
    break
  done
fi

cp "$THEME_DIR/powerlevel10k-doineann-${selected}.omp.json" "$THEME_DIR/$BASE_THEME"
echo "Applied the '${selected}' color theme."

echo "To see the change, you need to restart bash (or your terminal) again or run: 'source ~/.bashrc'."
