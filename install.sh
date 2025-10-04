#!/bin/bash

# ========================
# SYSTEM BASE SETUP
# ========================
# Update system and install core utilities

sudo cp pacman.conf /etc
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    linux-headers base-devel git cmake ninja go \
    networkmanager wget curl unzip tar \
    lsb-release reflector rsync less man-db man-pages \
    tzdata

# Enable essential services
sudo systemctl enable --now NetworkManager

# ========================
# NVIDIA DRIVER SETUP
# ========================
# Install NVIDIA open drivers and utilities
sudo pacman -S --needed --noconfirm \
    nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings egl-wayland

# Set kernel parameters for NVIDIA DRM modeset
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Add NVIDIA modules to initramfs
sudo sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
sudo mkinitcpio -P

# ========================
# HYPRLAND & GRAPHICS STACK
# ========================
# Install Hyprland and Wayland ecosystem with error handling
if ! sudo pacman -S --needed --noconfirm \
    hyprland waybar swaync wlroots0.18 grim slurp swaybg \
        wl-clipboard cliphist xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt6-wayland qt5-wayland \
        gtk3 gtk4 nwg-look cantarell-fonts 2>/tmp/hyprland-error.log
then
    echo "Ошибка установки Hyprland! Лог ошибок:"
    cat /tmp/hyprland-error.log
    exit 1
fi

# ========================
# WAYLAND ESSENTIALS
# ========================
sudo pacman -S --needed --noconfirm \
    lib32-vulkan-icd-loader vulkan-icd-loader \
    seatd

sudo usermod -aG seat "$USER"
sudo systemctl enable seatd.service

# ========================
# FONTS AND LOCALE
# ========================
# Install popular fonts and set locale
sudo pacman -S --needed --noconfirm \
    noto-fonts ttf-dejavu ttf-liberation ttf-opensans ttf-font-awesome

# Uncomment ru_RU.UTF-8 locale and generate
sudo sed -i 's/#ru_RU.UTF-8/ru_RU.UTF-8/' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=ru_RU.UTF-8

# ========================
# BLUETOOTH & AUDIO
# ========================
sudo pacman -S --needed --noconfirm \
    bluez bluez-utils blueman pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber sof-firmware alsa-utils pavucontrol easyeffects

sudo systemctl enable --now bluetooth

# ========================
# AUR HELPER (yay)
# ========================
if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin && makepkg -si --noconfirm && cd ..
    rm -rf yay-bin
fi

# ========================
# AUR PACKAGES
# ========================
yay -S --noconfirm  --overwrite='*' \
    zen-browser-bin nekoray-bin sing-geoip-common sing-geoip-db sing-geoip-rule-set \
    sing-geosite-common sing-geosite-db sing-geosite-rule-set \
    apple-font ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-google-fonts-git nerd-fonts-inter \
    whitesur-gtk-theme whitesur-icon-theme whitesur-cursor-theme-git papirus-icon-theme-git \
    hyprlock-git hyprpaper-git hyprshot wofi-emoji hyprpicker wlogout spotify

sudo pacman -S noto-fonts-emoji

# Fix nekoray
sudo /usr/bin/setcap cap_net_admin=ep /usr/lib/nekoray/nekobox_core

# ========================
# DESKTOP APPS
# ========================
sudo pacman -S --needed --noconfirm \
    nautilus gnome-keyring polkit-gnome telegram-desktop xdotool btop bitwarden discord chromium micro eza

# ========================
# ZSH & SHELL SETUP
# ========================
sudo pacman -S --needed --noconfirm zsh starship
sudo chsh -s /usr/bin/zsh "$USER"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp .zshrc ~/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/jirutka/zsh-shift-select.git ~/.zsh-shift-select

# ========================
# NODE, BUN, ZED
# ========================
sudo pacman -S --needed --noconfirm nodejs npm uv
curl -fsSL https://bun.sh/install | bash
curl -f https://zed.dev/install.sh | ZED_CHANNEL=preview sh
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc

# ========================
# THEMES, ICONS, WALLPAPER
# ========================
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
gtk-update-icon-cache -f -t ~/.local/share/icons/Papirus-Dark
cp wallpaper.png ~/

# ========================
# CONFIG FILES
# ========================
cp -r .config ~/

# ========================
# FINAL REBOOT
# ========================
echo "Installation complete. Rebooting system..."
sudo reboot

# ========================
# APPS
# ========================
yay -S beekeeper-studio obs-studio-git


# ========================
# ENGLISH COMMENTS
# ========================
# This script sets up a full-featured Arch Linux desktop with Hyprland and NVIDIA (open-source) drivers.
# It includes all essential packages, fonts, localization, Bluetooth, audio, AUR helper, and user applications.
# NVIDIA Wayland variables are set for best compatibility.
# The system is ready for daily use after reboot.
