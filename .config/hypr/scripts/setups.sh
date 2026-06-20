#!/bin/bash

ROFI_THEME="
configuration { show-icons: true; }
window { width: 800px; border-radius: 15px; padding: 20px; }
mainbox { children: [ listview ]; }
inputbar { enabled: false; }
listview { columns: 4; lines: 3; spacing: 15px; padding: 10px; }
element { orientation: vertical; padding: 15px; border-radius: 10px; }
element-icon { size: 120px; horizontal-align: 0.5; }
element-text { horizontal-align: 0.5; vertical-align: 0.5; padding: 10px 0 0 0; }
"

DIR="$HOME/.config/hypr/scripts/previews"

options="Berserk\0icon\x1f$DIR/berserk.svg\n"
options+="Gojo\0icon\x1f$DIR/gojo.svg\n"
options+="L\0icon\x1f$DIR/l.svg\n"
options+="Vampire\0icon\x1f$DIR/vampire.svg\n"
options+="Anime\0icon\x1f$DIR/anime.svg\n"
options+="Code\0icon\x1f$DIR/code.svg\n"
options+="Social\0icon\x1f$DIR/social.svg\n"
options+="Gaming\0icon\x1f$DIR/gaming.svg\n"
options+="Matrix\0icon\x1f$DIR/matrix.svg\n"
options+="Synthwave\0icon\x1f$DIR/synthwave.svg\n"
options+="Cyberpunk\0icon\x1f$DIR/cyberpunk.svg\n"
options+="Suicide\0icon\x1f$DIR/suicide.svg\n"
options+="Fake Sad\0icon\x1f$DIR/fake-sad.svg\n"
options+="Goon\0icon\x1f$DIR/goon.svg\n"
options+="Manga2\0icon\x1f$DIR/manga2.svg\n"
options+="Fuck\0icon\x1f$DIR/fuck.svg\n"
options+="Aheago\0icon\x1f$DIR/aheago.svg\n"
options+="Arch Ultra\0icon\x1f$DIR/arch-ultra.svg\n"
options+="Noctalia Shell\0icon\x1f$DIR/synthwave.svg\n"
options+="Default Hyprpanel\0icon\x1f$DIR/arch-ultra.svg\n"

choice=$(echo -e "$options" | rofi -dmenu -i -p "󰕧 Choisir un Setup :" -theme-str "$ROFI_THEME")

killall cava 2>/dev/null

if [ -n "$choice" ]; then
    hyprctl dispatch workspace empty
fi

# Helper ultra-robuste pour s'assurer que les fenêtres se placent parfaitement (2x2)
wait_for_window() {
    local old_count=$(hyprctl clients -j | jq length)
    local count=$old_count
    local timeout=0
    while [ "$count" -eq "$old_count" ] && [ $timeout -lt 20 ]; do
        sleep 0.1
        count=$(hyprctl clients -j | jq length)
        timeout=$((timeout+1))
    done
    sleep 0.1
}

launch_2x2() {
    eval "$1" &
    wait_for_window
    local addr1=$(hyprctl activewindow -j | jq -r '.address')
    
    eval "$2" &
    wait_for_window
    local addr2=$(hyprctl activewindow -j | jq -r '.address')
    
    hyprctl dispatch focuswindow address:$addr1
    sleep 0.1
    eval "$3" &
    wait_for_window
    
    hyprctl dispatch focuswindow address:$addr2
    sleep 0.1
    eval "$4" &
}

CAVA_COLOR=""

# Extraire la couleur d'accentuation principale (color1) générée par Matugen
MATUGEN_COLOR=$(grep -m1 "\$color1 =" ~/.config/hypr/matugen-colors.conf | grep -oE '[a-fA-F0-9]{6}' || echo "")

if [ -n "$MATUGEN_COLOR" ]; then
    ~/.config/hypr/scripts/cava-color.sh "$MATUGEN_COLOR"
fi

case "$choice" in
    "Berserk")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/berserk.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Gojo")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/gojo2.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "L")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/l.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Vampire")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/vampire-teeth.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Anime")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/anime-eyes.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Matrix")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/matrix.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Synthwave")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/synthwave.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Cyberpunk")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/cyberpunk.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Suicide")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/suicide.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Fake Sad")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/fake-sad.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Goon")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/goon.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Manga2")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/manga2.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Fuck")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/fuck.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Aheago")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/aheago.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Arch Ultra")
        CAVA_COLOR="$MATUGEN_COLOR"
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/arch-ultra.txt --logo-color-1 red" "kitty --hold -e tty-clock -c -C 1 -b" "kitty --hold -e cmatrix -C red" "kitty -e cava"
        ;;
    "Code")
        code & sleep 1.5; kitty & sleep 0.2; kitty & sleep 0.2; kitty & sleep 0.2; kitty &
        ;;
    "Social")
        discord & sleep 1; spotify-launcher & sleep 0.5; firefox &
        ;;
    "Gaming")
        steam & sleep 1; discord & sleep 0.5; spotify-launcher &
        ;;
    "Noctalia Shell")
        # Kill current bars
        killall hyprpanel waybar quickshell 2>/dev/null
        sleep 0.5
        # Set wallpaper
        ~/.config/hypr/scripts/wallpapers/set.sh ~/.config/wallpapers/noctalia.png &
        # Launch Noctalia shell using standard quickshell
        quickshell -c noctalia-shell &
        # Launch preview terminals
        launch_2x2 "kitty --hold -e fastfetch --logo ~/.config/fastfetch/ascii/matrix.txt --logo-color-1 blue" "kitty --hold -e tty-clock -c -C 4 -b" "kitty --hold -e cmatrix -C blue" "kitty -e cava"
        ;;
    "Default Hyprpanel")
        # Kill Noctalia shell
        killall noctalia-shell quickshell 2>/dev/null
        sleep 0.5
        # Relaunch Hyprpanel
        hyprpanel &
        ;;
esac

if [ -n "$choice" ]; then
    sleep 0.1
fi
