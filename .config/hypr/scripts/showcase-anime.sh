#!/bin/bash

# Vider l'espace de travail
hyprctl dispatch workspace empty
sleep 1

# Trouver 4 images aléatoires
IMAGES=($(find "$HOME/.config/fastfetch-anime/waifu" -type f -name "*.png" | shuf -n 4))

CONFIG="$HOME/.config/fastfetch-anime/config-compact.jsonc"

# Lancer la première fenêtre (Top Left)
hyprctl dispatch exec "kitty --hold -e fastfetch -c $CONFIG --logo ${IMAGES[0]}"
sleep 1

# Lancer la deuxième fenêtre (Top Right)
hyprctl dispatch exec "kitty --hold -e fastfetch -c $CONFIG --logo ${IMAGES[1]}"
sleep 1

# Splitter en bas pour les deux prochaines
hyprctl dispatch movefocus l
sleep 0.5
hyprctl dispatch layoutmsg preselect d
hyprctl dispatch exec "kitty --hold -e fastfetch -c $CONFIG --logo ${IMAGES[2]}"
sleep 1

hyprctl dispatch movefocus r
sleep 0.5
hyprctl dispatch movefocus u
sleep 0.5
hyprctl dispatch layoutmsg preselect d
hyprctl dispatch exec "kitty --hold -e fastfetch -c $CONFIG --logo ${IMAGES[3]}"
