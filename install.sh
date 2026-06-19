#!/bin/bash

# === THE TROLL (BADASS EDITION) ===
clear
echo -e "\033[32m"
# Matrix / Hex Dump simulation
cat /dev/urandom | hexdump -C | grep -v "*" | head -n 80
echo -e "\033[0m"
sleep 0.5

clear
echo -e "\033[1;31m[!] WARNING: UNAUTHORIZED SYSTEM ACCESS DETECTED\033[0m"
sleep 0.8
echo -e "\033[1;31m[!] BYPASSING KERNEL SECURITY...\033[0m"
sleep 0.8
echo -e "\033[1;31m[!] INJECTING ANTIGRAVITY ROOTKIT...\033[0m"
sleep 0.5

echo -ne "\033[1;31mDecrypting Master Password: \033[0m["
for i in {1..40}; do
    echo -n "█"
    sleep 0.04
done
echo -e "] \033[1;32mACCESS GRANTED\033[0m"
sleep 1
clear

# Evil Skull ASCII Art
echo -e "\033[1;31m"
cat << "EOF"
    .                                                      .
        .n                   .                 .                  n.
  .   .dP                  dP                   9b                 9b.    .
 4    qXb         .       dX                     Xb       .        dXp     t
dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb
9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP
 9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP
  `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'
    `9XXXXXXXXXXXP' `9XX'   DIE    `98v8P'  HUMAN   `XXP' `9XXXXXXXXXXXP'
        ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~
                        )b.  .dbo.dP'`v'`9b.odb.  .dX(
                      ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.
                     dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb
                    dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb
                    9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP
                     `'      9XXXXXX(   )XXXXXXP      `'
                              XXXX X.`v'.X XXXX
                              XP^X'`b   d'`X^XX
                              X. 9  `   '  P .X
                              `b  `       '  d'
                               `             '
EOF
echo -e "\033[0m"

echo -e "\033[1;31mSYSTEM TAKEOVER COMPLETE. ALL YOUR DATA BELONGS TO US.\033[0m"
sleep 2.5
echo -e "\n\033[1;32m--> Nah, just kidding! 😎 Welcome to the Antigravity Dotfiles setup.\033[0m"
echo -e "\033[1;32m--> Let's make this system awesome. 🚀\033[0m"
sleep 2
clear
# ==================================

echo "--> Update system & install dependencies"
sudo pacman -Syu --noconfirm
yay -S --noconfirm hyprland kitty rofi-wayland waybar hyprpanel-git swww cliphist \
       grimblast-git power-profiles-daemon xwaylandvideobridge \
       btop cava spicetify-cli fastfetch

echo "--> Applying configurations..."
cp -r .config/* ~/.config/

echo "--> Checking Rust for H.I.C.D compilation..."
if ! command -v cargo &> /dev/null; then
    echo "Rust is missing. Installing rustup..."
    sudo pacman -S --noconfirm rustup
    rustup default stable
fi

echo "--> Building the H.I.C.D Brain..."
cd ~/.config/hypr/hicd-core
cargo build --release
mkdir -p ~/.local/bin
cp target/release/hicd ~/.local/bin/

echo "--> Activating the Daemon..."
systemctl --user enable --now hicd.service

echo ""
echo -e "\033[32mInstallation Complete! You can now launch Hyprland.\033[0m"
