#!/bin/bash

#####################################
#    Created by Fassih Fayyaz       #
#####################################

###############################################################################
# #                                                                           # #
# #                        Install Xorg and Qtile? (y/n)                     # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                        Install Xorg and Qtile? (y/n)                     # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " install_wm

if [[ $install_wm == "y" || $install_wm == "Y" ]]; then
    sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-apps
    echo "exec /usr/bin/qtile start" >> ~/.xinitrc
    sudo pacman -S --noconfirm qtile alacritty thunar
    sudo pacman -S --noconfirm python-psutil
    sudo pacman -S --noconfirm python-pywal
fi

###############################################################################
# #                                                                           # #
# #                     Install AUR Package Manager? (yay/paru)              # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                     Install AUR Package Manager? (yay/paru)              # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " aur_helper

if [[ $aur_helper == "yay" || $aur_helper == "paru" ]]; then
    sudo pacman -S --noconfirm base-devel
    cd ~
    git clone https://aur.archlinux.org/$aur_helper.git
    cd $aur_helper
    makepkg -si
fi

###############################################################################
# #                                                                           # #
# #                        Setup Fast Mirrors? (y/n)                         # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                        Setup Fast Mirrors? (y/n)                         # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " setup_mirrors

if [[ $setup_mirrors == "y" || $setup_mirrors == "Y" ]]; then
    $aur_helper -S --noconfirm rate-mirrors
    rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist
fi

###############################################################################
# #                                                                           # #
# #                         Install Wayland? (y/n)                           # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                         Install Wayland? (y/n)                           # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " install_wayland

if [[ $install_wayland == "y" || $install_wayland == "Y" ]]; then
    sudo pacman -S --noconfirm python-pywlroots xorg-xwayland
fi

###############################################################################
# #                                                                           # #
# #                    Install Important Programs? (y/n)                     # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                    Install Important Programs? (y/n)                     # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " install_programs

if [[ $install_programs == "y" || $install_programs == "Y" ]]; then
    sudo pacman -S --noconfirm git fastfetch ntfs-3g xdg-user-dirs picom rofi thunar thunar-archive-plugin xarchiver unrar unzip stow obsidian mousepad vlc dunst starship mesa-utils alsa-utils
    xdg-user-dirs-update
fi

# read -p "Set Fstab Permissions? (y/n) " set_fstab
# if [[ $set_fstab == "y" || $set_fstab == "Y" ]]; then
# echo "uid=1000,gid=1000,rw,user,exec,umask=000" | sudo tee -a /etc/fstab
# fi

###############################################################################
# #                                                                           # #
# #           Install Fonts and Apps before adding dotfiles? (y/n)           # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #           Install Fonts and Apps before adding dotfiles? (y/n)           # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " install_pre_dotfiles

if [[ $install_pre_dotfiles == "y" || $install_pre_dotfiles == "Y" ]]; then
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd ttf-liberation sxiv firefox rofi-emoji rofi-calc xdotool btop eza zoxide fzf polkit-gnome
    $aur_helper -S --noconfirm qtile-extras
fi

###############################################################################
# #                                                                           # #
# #                         Setup Dotfiles? (y/n)                            # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                         Setup Dotfiles? (y/n)                            # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " setup_dotfiles

if [[ $setup_dotfiles == "y" || $setup_dotfiles == "Y" ]]; then
    cd ~
    git clone https://github.com/FassihFayyaz/dotfiles.git
    cd dotfiles/
    stow . --adopt
fi

###############################################################################
# #                                                                           # #
# #                          Setup Themes? (y/n)                             # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                          Setup Themes? (y/n)                             # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " setup_themes

if [[ $setup_themes == "y" || $setup_themes == "Y" ]]; then
    sudo pacman -S --noconfirm gnome-themes-extra nwg-look papirus-icon-theme
    $aur_helper -S --noconfirm adwaita-qt5 adwaita-qt6 qt5ct qt6ct python-pywalfox
fi

###############################################################################
# #                                                                           # #
# #                    Install Optional Softwares? (y/n)                     # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                    Install Optional Softwares? (y/n)                     # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " install_important

if [[ $install_important == "y" || $install_important == "Y" ]]; then
    sudo pacman -S --noconfirm corectrl kodi flameshot copyq qbittorrent linux-headers pavucontrol
    $aur_helper -S --noconfirm vesktop-bin green-tunnel thorium-browser-bin noisetorch-bin polychromatic vscodium-bin
fi

###############################################################################
# #                                                                           # #
# #                          Setup Gaming? (y/n)                             # #
# #                                                                           # #
###############################################################################

read -p " $(printf "%$(($(tput cols)))s\n" '' | tr " " "#")
# #                          Setup Gaming? (y/n)                             # #
$(printf "%$(($(tput cols)))s\n" '' | tr " " "#") " setup_gaming

if [[ $setup_gaming == "y" || $setup_gaming == "Y" ]]; then
   sudo pacman -S --noconfirm steam lutris goverlay mangohud gamemode wine-staging
   $aur_helper -S --noconfirm protonup-qt-bin
fi