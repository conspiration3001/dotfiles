#!/bin/bash
# Capture the active window exactly and copy to clipboard
GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
grim -g "$GEOM" - | wl-copy
notify-send "📸 Capture copiée !" "La fenêtre a été copiée dans le presse-papier."
