#!/bin/bash

read -p "Install Xorg and Qtile? (y/n) " install_wm
if [[ $install_wm == "y" || $install_wm == "Y" ]]; then
    sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-apps
    sudo mkdir ~/.xinitrc
    echo "exec /usr/bin/qtile start" >> ~/.xinitrc
    sudo pacman -S --noconfirm qtile alacritty thunar
    sudo pacman -S --noconfirm python-psutil
    yay -S --noconfirm qtile-extras
    sudo pacman -S --noconfirm python-pywal
fi

read -p "Install AUR Package Manager? (y/n) " install_aur
if [[ $install_aur == "y" || $install_aur == "Y" ]]; then
    sudo pacman -S --noconfirm base-devel
    cd ~
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
fi

read -p "Setup Fast Mirrors? (y/n) " setup_mirrors
if [[ $setup_mirrors == "y" || $setup_mirrors == "Y" ]]; then
    yay -S --noconfirm rate-mirrors
    rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist
fi

read -p "Install Wayland? (y/n) " install_wayland
if [[ $install_wayland == "y" || $install_wayland == "Y" ]]; then
    sudo pacman -S --noconfirm python-pywlroots xorg-xwayland
fi

read -p "Install Important Programs? (y/n) " install_programs
if [[ $install_programs == "y" || $install_programs == "Y" ]]; then
    sudo pacman -S --noconfirm git fastfetch ntfs-3g xdg-user-dirs picom rofi thunar thunar-archive-plugin xarchiver unrar unzip stow obsidian mousepad vlc dunst starship mesa-utils alsa-utils
    xdg-user-dirs-update
fi

# read -p "Set Fstab Permissions? (y/n) " set_fstab
# if [[ $set_fstab == "y" || $set_fstab == "Y" ]]; then
#     echo "uid=1000,gid=1000,rw,user,exec,umask=000" | sudo tee -a /etc/fstab
# fi

read -p "Install Fonts and Apps before adding dotfiles? (y/n) " install_pre_dotfiles
if [[ $install_pre_dotfiles == "y" || $install_pre_dotfiles == "Y" ]]; then
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd ttf-liberation sxiv firefox firefox-i18n-ur rofi-emoji rofi-calc xdotool btop eza zoxide fzf polkit-gnome thorium-browser-bin 
fi

read -p "Setup Dotfiles? (y/n) " setup_dotfiles
if [[ $setup_dotfiles == "y" || $setup_dotfiles == "Y" ]]; then
    cd ~
    git clone https://github.com/FassihFayyaz/dotfiles.git
    cd dotfiles/
    stow . --adopt
fi

read -p "Setup Themes? (y/n) " setup_themes
if [[ $setup_themes == "y" || $setup_themes == "Y" ]]; then
    sudo pacman -S --noconfirm gnome-themes-extra nwg-look papirus-icon-theme 
    yay -S --noconfirm adwaita-qt5 adwaita-qt6 qt5ct qt6ct python-pywalfox
fi

read -p "Install Optional Softwares? (y/n) " install_important
if [[ $install_important == "y" || $install_important == "Y" ]]; then
    sudo pacman -S --noconfirm corectrl kodi flameshot noisetorch-bin copyq qbittorrent polychromatic linux-headers
    yay -S --noconfirm vesktop green-tunnel
fi

read -p "Setup Gaming? (y/n) " setup_gaming
if [[ $setup_gaming == "y" || $setup_gaming == "Y" ]]; then
    sudo pacman -S --noconfirm steam lutris goverlay mangohud gamemode wine-staging
    yay -S --noconfirm protonup-qt-bin
fi