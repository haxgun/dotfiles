#!/bin/bash

echo "Setting timezone to Asia/Yekaterinburg"
timedatectl set-timezone Asia/Yekaterinburg

echo "Installing essential packages"
sudo pacman -S --needed --noconfirm git micro chromium eza base-devel ninja yaml-cpp cmake go

echo "Cloning and installing yay"
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd ..

echo "Installing additional packages with yay"
yay -S --noconfirm zen-browser-bin nekoray-bin sing-geoip-common sing-geoip-db sing-geoip-rule-set sing-geosite-common sing-geosite-db sing-geosite-rule-set
sudo /usr/bin/setcap cap_net_admin=ep /usr/lib/nekoray/nekobox_core
yay -S --noconfirm apple-font ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-google-fonts-git ttf-apple-emoji nerd-fonts-inter

echo "Installing desktop applications"
sudo pacman -S --noconfirm nautilus waybar swaync polkit-gnome gnome-keyring easyeffects telegram-desktop copyq btop unzip bitwarden

echo "Setting up zsh and oh-my-zsh"
sudo pacman -S --noconfirm zsh starship
sudo chsh -s /usr/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp .zshrc ~/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo "Installing bun"
curl -fsSL https://bun.sh/install | bash

echo "Installing Node.js and related packages"
sudo pacman -S --noconfirm nodejs npm uv

echo "Installing Zed editor"
yay -S --noconfirm zed-git
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc

echo "Setting locale to ru_RU.UTF-8"
sudo cp locale.gen /etc/locale.gen
sudo locale-gen
sudo localectl set-locale ru_RU.UTF-8

echo "Installing additional tools and dependencies"
sudo pacman -S --noconfirm qt6-tools gtk4 gtk3 brightnessctl fastfetch xdg-desktop-portal-hyprland xdg-desktop-portal-gtk nwg-look cantarell-fonts

echo "Installing themes and icons from AUR"
yay -S --noconfirm whitesur-gtk-theme whitesur-icon-theme whitesur-cursor-theme-git

echo "Creating configuration directories"
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

echo "Updating icon cache"
gtk-update-icon-cache -f -t ~/.local/share/icons/Papirus-Dark

echo "Copying configuration files"
cp .config ~/

echo "Installing additional utilities"
yay -S --noconfirm hyprlock-git hyprpaper-git hyprshot wofi-emoji hyprpicker
yay -S --noconfirm wlogout spotify
sudo pacman -S --noconfirm hyprpicker

echo "Installing discord"
sudo pacman -S --noconfirm discord

echo "Copying wallpaper"
cp wallpaper.png ~/

echo "Installing bluetooth"
sudo pacman -S --noconfirm bluez bluez-utils blueman
sudo modprobe btusb
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

echo "Copy .config"
cp .config ~/

echo "Reboot"
sudo reboot
