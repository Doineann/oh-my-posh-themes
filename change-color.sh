#!/bin/bash

# change-color.sh — Color picker for doineann.omp.json
#
# Each // MAIN-COLOR tag marks a location where the color on the NEXT line
# should be replaced with the user-provided hex color.
# The marker itself stays as "// MAIN-COLOR" (no color value).
#
# Usage:   ./change-color.sh #FF5733    # change all marked colors to that color
#          ./change-color.sh            # prompts for input, or restores default if empty
#

TARGET_FILE="doineann.omp.json"

# --- 1. Extract the default (default) color from line 1 of the JSON file ---
DEFAULT_COLOR=$(head -n 3 "$TARGET_FILE" | grep -oE '#[0-9A-Fa-f]{6}' | head -1)

if [ -z "$DEFAULT_COLOR" ]; then
    echo "Error: Could not find a default color on line 1 of $TARGET_FILE." >&2
    exit 1
fi

echo "Default color (from line 1): $DEFAULT_COLOR"

# --- 2. Get the new color from argument or prompt ---
if [ -n "$1" ]; then
    NEW_COLOR="$1"
else
    echo ""
    read -p "Enter a hex color (or press Enter to restore default [$DEFAULT_COLOR]): " USER_INPUT
fi

if [ -z "$USER_INPUT" ]; then
    # No input given — restore the default color
    NEW_COLOR="$DEFAULT_COLOR"
    echo "No color specified. Restoring default: $NEW_COLOR"
else
    # Validate the provided color
    if [[ ! "$USER_INPUT" =~ ^#[0-9A-Fa-f]{3,6}$ ]]; then
        echo "Error: Invalid color code '$USER_INPUT'. Please provide a valid 3-digit or 6-digit hex color (e.g., #FF5733)." >&2
        exit 1
    fi
    NEW_COLOR="$USER_INPUT"
fi

# --- 3. Find all marker lines and replace colors on the NEXT line ---
MARKER_LINES=$(grep -n "MAIN-COLOR" "$TARGET_FILE" | cut -d: -f1)

if [ -z "$MARKER_LINES" ]; then
    echo "Error: No '// MAIN-COLOR' markers found in $TARGET_FILE." >&2
    exit 1
fi

for MARKER_LINE in $MARKER_LINES; do
    NEXT_LINE=$((MARKER_LINE + 1))

    # Get the content of the next line and find any hex color it contains
    NEXT_CONTENT=$(sed -n "${NEXT_LINE}p" "$TARGET_FILE")

    # Extract any hex color from this line (e.g., "background": "#337733")
    OLD_COLOR=$(echo "$NEXT_CONTENT" | grep -oE '#[0-9A-Fa-f]{6}' | head -1)

    if [ -z "$OLD_COLOR" ]; then
        echo "Warning: No color found on line $NEXT_LINE. Skipping." >&2
        continue
    fi

    # Replace the old color with the new one on this specific line only
    sed -i "${NEXT_LINE}s/$OLD_COLOR/$NEW_COLOR/" "$TARGET_FILE"

    echo "  Replaced '$OLD_COLOR' → '$NEW_COLOR' at line $NEXT_LINE"
done

echo ""
echo "Done. Modified $TARGET_FILE with color: $NEW_COLOR"
