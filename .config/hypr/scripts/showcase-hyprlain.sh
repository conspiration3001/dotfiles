#!/bin/bash
exec > /tmp/hyprlain.log 2>&1
set -x

# Vider l'espace de travail
hyprctl dispatch workspace empty
sleep 1

# Variables pour forcer le thème rouge (Hyprlain) sur Kitty
KITTY_OPTS="-o foreground=#CE7688 -o background=#000000 -o color1=#AB4642 -o color9=#AB4642 -o color2=#CE7688 -o color10=#CE7688 -o color5=#CE7688"

# 1. Top Left: ASCII Anim (wired)
hyprctl dispatch exec "kitty $KITTY_OPTS --hold -e bash -c 'tplay -l -cWIRED /home/conspiration3001/.config/assets/media/anim/wiredfriendFIN.gif'"
sleep 1

# 2. Top Right: Neofetch Hyprlain (Red Skull)
hyprctl dispatch exec "kitty $KITTY_OPTS --hold -e bash -c 'neofetch --source /home/conspiration3001/.config/neofetch-hyprlain/logo --config /home/conspiration3001/.config/neofetch-hyprlain/config.conf; read'"
sleep 1

# On a deux fenêtres en mode split (Gauche / Droite). On split en bas.
hyprctl dispatch movefocus l
sleep 0.5
hyprctl dispatch layoutmsg preselect d

# 3. Bottom Left: Lain Quotes
hyprctl dispatch exec "kitty $KITTY_OPTS --hold -e bash -c \"cbonsai -lt0.005 -iw2 -cwired -k0,1,2,12 -M10 -L64 -m 'What is the definition of God?'\""
sleep 1

hyprctl dispatch movefocus r
sleep 0.5
hyprctl dispatch movefocus u
sleep 0.5
hyprctl dispatch layoutmsg preselect d

# 4. Bottom Right: Cmatrix
hyprctl dispatch exec "kitty $KITTY_OPTS --hold -e bash -c 'cmatrix -b -u 2'"
