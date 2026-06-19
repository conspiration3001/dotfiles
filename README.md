# 🌌 Antigravity Dotfiles: Hyper-Optimized Arch Linux + Hyprland

![Hyprland](https://img.shields.io/badge/WM-Hyprland-blue?style=for-the-badge&logo=hyprland)
![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-1793d1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Rust](https://img.shields.io/badge/Powered_by-Rust-orange?style=for-the-badge&logo=rust)

Welcome to the **dnono2134-a11y** dotfiles repository. This isn't just another rice. This is a deeply optimized, context-aware environment that adapts to what you are doing in real-time. 

Built around **Hyprland**, this setup prioritizes maximum performance, zero bloat, and an adaptive AI-like contextual daemon written from scratch in Rust.

---

## ✨ Features

- **Blazing Fast Performance**: Zero background bloat. Hardware acceleration enabled for Spotify, Discord (Vesktop via XWayland Video Bridge), and kitty.
- **H.I.C.D (Hyper-Intelligence Context Daemon)**: A custom Rust daemon that lives in the background with 0% CPU footprint. It hooks directly into the Hyprland UNIX socket and dynamically alters the Linux kernel CPU governor (`powerprofilesctl`) and the compositor state depending on the exact app you are focusing on.
- **Dynamic Themes & Wallpapers**: Includes a huge collection of custom wallpapers, integrated with a real-time Theme Switcher.
- **Hyprpanel**: Modern, highly functional top bar using AGS/Astal.
- **Dynamic Workspaces**: Handled perfectly via Hyprland's `master` or `dwindle` layouts.
- **Beautiful Rofi**: Custom application launcher, clipboard manager (`cliphist`), and emoji picker (`rofimoji`).

---

## 🧠 What is H.I.C.D?

The **Hyper-Intelligence Context Daemon** is the secret sauce of this rice. It uses asynchronous Rust (`tokio`) to monitor Hyprland's `activewindow` socket events in real-time.

Depending on the window you focus on, H.I.C.D triggers **System States**:
1. 🍃 **Chill Mode** (Spotify, Discord, Thunar): Switches the CPU governor to `power-saver`. Activates UI shadows.
2. 🧠 **Neural Focus** (Kitty, VSCode, IDEs): Switches the CPU governor to `balanced`. Activates UI blur and dims distractions.
3. 🔥 **Overdrive** (Steam, Games): Switches the CPU governor to `performance`. Kills UI effects to dedicate 100% of the GPU and CPU to the game.

*Note: The code for H.I.C.D is located in `~/.config/hypr/hicd-core/`.*

---

## 🚀 Installation

*Warning: This setup assumes you are on Arch Linux with an Intel/AMD system.*

### 1. Prerequisites (Packages)
Install the required dependencies using `pacman` and `yay`:
```bash
yay -S hyprland kitty rofi-wayland waybar hyprpanel-git swww cliphist \
       grimblast-git power-profiles-daemon xwaylandvideobridge \
       btop cava spicetify-cli fastfetch
```

### 2. Clone and Copy
Clone this repository and copy the contents of the `.config` folder directly into your own `~/.config` directory:
```bash
git clone https://github.com/dnono2134-a11y/dotfiles.git
cd dotfiles
cp -r .config/* ~/.config/
```

### 3. Build & Enable H.I.C.D
You need `rust` and `cargo` installed.
```bash
cd ~/.config/hypr/hicd-core
cargo build --release
mkdir -p ~/.local/bin
cp target/release/hicd ~/.local/bin/
systemctl --user enable --now hicd.service
```

---

## ⌨️ Keybindings

Here are the primary keybindings to navigate the system (Mod key is `SUPER` / Windows Key):

| Keybind | Action |
| :--- | :--- |
| `SUPER + T` | Launch Terminal (kitty) |
| `SUPER + A` | Open App Launcher (rofi) |
| `SUPER + E` | Open File Manager (thunar) |
| `SUPER + C` | Kill active window |
| `SUPER + V` | Open Clipboard Manager |
| `SUPER + K` | Lock Screen (hyprlock) |
| `SUPER + X` | 🖥️ Open Setups Menu |
| `SUPER + Y` | 🎨 Theme Switcher |
| `SUPER + I` | Launch System AI Agent |
| `SUPER + F` | Toggle floating window |
| `SUPER + S` | Toggle layout split |
| `SUPER + [Arrow Keys]` | Move focus |
| `SUPER + [1-9]` | Switch workspace |
| `SUPER + SHIFT + [1-9]`| Move window to workspace |
| `SUPER + Print` | Select area to screenshot |
| `ALT + R` | Enter Resize Submap (Arrow keys to resize, Esc to exit) |

---

## 🧹 Maintenance Tips
Keep your system as clean as this rice by occasionally running:
- `yay -Sc` (Clears pacman cache to save disk space)
- `pacman -Qtdq | sudo pacman -Rns -` (Removes orphan packages)

Enjoy the setup! Built with precision. ☕
