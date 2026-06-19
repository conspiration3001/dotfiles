#!/bin/bash

# === THE HYPRLAND HOSTAGE TROLL ===
clear
echo -e "\033[1;31m[!] FATAL ERROR: CONFLICTING KERNEL MODULES DETECTED\033[0m"
echo -e "\033[1;31m[!] ATTEMPTING TO HOT-RELOAD GPU DRIVERS...\033[0m"
sleep 1

# Spam scary notifications on the desktop
for i in {1..5}; do
    notify-send -u critical -t 4000 "⚠️ GPU MELTDOWN IMMINENT" "VRAM Corruption at memory address 0x00${RANDOM}F. Thermal limits exceeded."
    sleep 0.2
done

echo -e "\033[1;31m[!] DRIVER RELOAD FAILED. EMERGENCY DISPLAY SHUTDOWN INITIATED.\033[0m"
sleep 1

# The ultimate heart attack: literally turn off the monitor
hyprctl dispatch dpms off
sleep 2.5

# Turn the monitor back on
hyprctl dispatch dpms on
sleep 0.5

clear
echo -e "\033[1;32m--> Nah, just kidding! Your GPU and screen are perfectly fine. 😎\033[0m"
echo -e "\033[1;32m--> Welcome to the Antigravity Dotfiles setup. Let's make this system awesome! 🚀\033[0m"
sleep 2
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
