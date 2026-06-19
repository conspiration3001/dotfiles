#!/bin/bash

# Options du menu
OPTIONS="Berserk (Smooth)\nAnime Waifu (Neon)\nBlackArch (Hacker)"

# Lancer rofi
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Animations Theme:")

if [ "$CHOICE" = "Berserk (Smooth)" ]; then
    cp ~/.config/hypr/configs/animations-berserk.conf ~/.config/hypr/configs/animations.conf
    cp ~/.config/hypr/configs/hyprcolors-berserk.conf ~/.config/hypr/configs/hyprcolors.conf
    notify-send "Thème" "Thème Berserk activé !"
elif [ "$CHOICE" = "Anime Waifu (Neon)" ]; then
    cp ~/.config/hypr/configs/animations-crazy.conf ~/.config/hypr/configs/animations.conf
    cp ~/.config/hypr/configs/hyprcolors-crazy.conf ~/.config/hypr/configs/hyprcolors.conf
    notify-send "Thème" "Thème Anime (Neon) activé !"
elif [ "$CHOICE" = "BlackArch (Hacker)" ]; then
    cp ~/.config/hypr/configs/animations-blackarch.conf ~/.config/hypr/configs/animations.conf
    cp ~/.config/hypr/configs/hyprcolors-blackarch.conf ~/.config/hypr/configs/hyprcolors.conf
    notify-send "Thème" "Thème BlackArch (Hacker) activé !"
else
    exit 0
fi

# Recharger Hyprland pour appliquer les nouvelles animations
hyprctl reload
