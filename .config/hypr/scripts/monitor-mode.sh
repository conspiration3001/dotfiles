#!/bin/bash

# Configuration Rofi
rofi_config="$HOME/.config/rofi/config.rasi"

options="💻 Écran PC uniquement\n🖧 Étendre l'affichage\n🪞 Dupliquer (Miroir)\n🖥️ Écrans externes uniquement"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Mode d'affichage" -config "$rofi_config")

# Obtenir la liste des écrans externes (tout sauf eDP-1)
externals=$(hyprctl monitors all -j | jq -r '.[].name' | grep -v eDP-1)

case "$chosen" in
    "💻 Écran PC uniquement")
        # On active le PC et on désactive les autres
        hyprctl keyword monitor eDP-1,preferred,auto,1
        for mon in $externals; do
            hyprctl keyword monitor "$mon",disable
        done
        ;;
    "🖧 Étendre l'affichage")
        # On active tous les écrans en mode étendu (hyprctl reload remet les règles par défaut)
        hyprctl reload
        ;;
    "🪞 Dupliquer (Miroir)")
        # On active le PC et on demande aux autres de faire le miroir de eDP-1
        hyprctl keyword monitor eDP-1,preferred,auto,1
        for mon in $externals; do
            hyprctl keyword monitor "$mon",preferred,auto,1,mirror,eDP-1
        done
        ;;
    "🖥️ Écrans externes uniquement")
        # On désactive le PC et on active les autres
        hyprctl keyword monitor eDP-1,disable
        for mon in $externals; do
            hyprctl keyword monitor "$mon",preferred,auto,1
        done
        ;;
esac
