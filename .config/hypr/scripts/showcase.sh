#!/bin/bash

# Nettoyer les fenêtres existantes si on relance le script
hyprctl dispatch workspace empty

sleep 1

# 1. Lancer btop (prend tout l'écran au début, puis restera à gauche pour avoir assez de place)
hyprctl dispatch exec "kitty -e btop"
sleep 2

# 2. Lancer fastfetch (se place à droite)
hyprctl dispatch exec "kitty --hold -e fastfetch"
sleep 2

# 3. Séparer fastfetch vers le bas pour mettre cmatrix
hyprctl dispatch layoutmsg preselect d
hyprctl dispatch exec "kitty --hold -e cmatrix"
sleep 2

# 4. Séparer cmatrix vers le bas pour tty-clock
hyprctl dispatch layoutmsg preselect d
hyprctl dispatch exec "kitty --hold -e tty-clock -c -C 4 -b"
sleep 2

# 5. Séparer tty-clock vers la droite pour cava
hyprctl dispatch layoutmsg preselect r
hyprctl dispatch exec "kitty --hold -e cava"
