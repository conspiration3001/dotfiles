#!/bin/bash

# Prendre un screenshot invisible si aucune couleur n'est fournie, sinon utiliser l'argument
if [ -n "$1" ]; then
    HEX="$1"
    # Nettoyer le # si présent
    HEX="${HEX//\#/}"
else
    HEX=$(grim - | magick - -resize 1x1\! -format "%[hex:u.p{0,0}]" info:-)
fi

# S'assurer qu'on a bien un HEX (6 caractères)
if [ -z "$HEX" ] || [ ${#HEX} -ne 6 ]; then
    exit 1
fi

# Convertir le code HEX en composantes RGB (base 16 à base 10)
R=$((16#${HEX:0:2}))
G=$((16#${HEX:2:2}))
B=$((16#${HEX:4:2}))

# Fonction pour éclaircir une couleur
lighten() {
    local val=$1
    local percent=$2
    local new_val=$(echo "$val + (255 - $val) * $percent" | bc)
    printf "%02X" ${new_val%.*}
}

# Générer un dégradé de 6 couleurs basé sur la couleur dominante
c1="#$(lighten $R 0.8)$(lighten $G 0.8)$(lighten $B 0.8)"
c2="#$(lighten $R 0.6)$(lighten $G 0.6)$(lighten $B 0.6)"
c3="#$(lighten $R 0.4)$(lighten $G 0.4)$(lighten $B 0.4)"
c4="#$(lighten $R 0.2)$(lighten $G 0.2)$(lighten $B 0.2)"
c5="#$HEX"
c6="#$(lighten $R 0.0)$(lighten $G 0.0)$(lighten $B 0.0)"

# Mettre à jour la configuration de Cava
CAVA_CONF="$HOME/.config/cava/config"

sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$c1'/" "$CAVA_CONF"
sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$c2'/" "$CAVA_CONF"
sed -i "s/^gradient_color_3 = .*/gradient_color_3 = '$c3'/" "$CAVA_CONF"
sed -i "s/^gradient_color_4 = .*/gradient_color_4 = '$c4'/" "$CAVA_CONF"
sed -i "s/^gradient_color_5 = .*/gradient_color_5 = '$c5'/" "$CAVA_CONF"
sed -i "s/^gradient_color_6 = .*/gradient_color_6 = '$c6'/" "$CAVA_CONF"

# Recharger cava en envoyant le signal SIGUSR1
killall -SIGUSR1 cava 2>/dev/null || true
