#!/bin/bash

# === THE TROLL ===
clear
echo -e "\033[31m[CRITICAL]\033[0m Traces of Windows detected in memory."
echo -n "Initiating emergency wipe of all drives "
for i in {1..4}; do echo -n "."; sleep 0.6; done
echo ""
echo -e "Erasing /dev/sda... \033[32m[OK]\033[0m"
sleep 0.5
echo -e "Erasing /dev/nvme0n1... \033[32m[OK]\033[0m"
sleep 1
echo -e "\033[32mJust kidding! Welcome to the Antigravity Dotfiles setup.\033[0m"
echo "Let's make this system awesome. 🚀"
sleep 2
echo ""
# =================

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
