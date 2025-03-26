#!/bin/bash

timedatectl set-timezone Asia/Yekaterinburg
sudo pacman -S --needed git chromoim eza base-devel ninja yaml-cpp cmake go && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
yay -S nekoray-bin sing-geoip-common sing-geoip-db sing-geoip-rule-set sing-geosite-common sing-geosite-db sing-geosite-rule-set
sudo /usr/bin/setcap cap_net_admin=ep /usr/lib/nekoray/nekobox_core
yay -S apple-font ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-google-fonts-git
sudo pacman -S nautilus waybar swaync polkit-gnome easyeffects telegram-desktop copyq btop unzip bitwarden
sudo pacman -S zsh starship
sudo chsh -s /usr/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
curl -fsSL https://bun.sh/install | bash
sudo pacman -S nodejs npm uv
curl -f https://zed.dev/install.sh | sh
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc


sudo cp locale.gen /etc/locale.gen
sudo locale-gen
sudo localectl set-locale ru_RU.UTF-8

sudo pacman -S qt6-tools gtk4 gtk3 brightnessctl fastfetch xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
yay -S lxappearance

#!/bin/bash

# Установка зависимостей
sudo pacman -S --noconfirm cantarell-fonts yay

# Установка тем и иконок из AUR
yay -S --noconfirm graphite-gtk-theme papirus-icon-theme-git apple_cursor

# Создание директорий для конфигурации
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

# Настройка GTK 3
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Graphite-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Cantarell 11
gtk-cursor-theme-name=macOS
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=0
EOF

# Настройка GTK 4
cat > ~/.config/gtk-4.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Graphite-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Cantarell 11
gtk-cursor-theme-name=macOS
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=0
EOF

# Обновление кэша иконок
gtk-update-icon-cache -f -t ~/.local/share/icons/Papirus-Dark

echo "Установка завершена. Для применения изменений перезапустите приложения или сеанс системы."


yay -S hyprlock-git hyprpaper-git wlogout hyprshot wofi-emoji
cp wallpaper ~/
