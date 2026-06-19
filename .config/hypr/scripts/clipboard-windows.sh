#!/bin/bash
# Script to mimic Windows Win+V clipboard with beautiful UI and auto-paste

# Show clipboard history using Rofi with our custom beautiful theme
selected=$(cliphist list | rofi -dmenu -theme ~/.config/rofi/clipboard.rasi -p "📋")

# If nothing was selected (user pressed Escape), exit cleanly
if [ -z "$selected" ]; then
    exit 0
fi

# Decode the selected item and copy it to Wayland clipboard
echo "$selected" | cliphist decode | wl-copy

# Wait a fraction of a second for Rofi window to close and Wayland to sync
sleep 0.1

# Simulate Ctrl+V to paste the content directly into the active window
wtype -M ctrl -k v -m ctrl
