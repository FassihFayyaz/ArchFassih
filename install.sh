#!/bin/bash
#####################################
#    Created by Fassih Fayyaz       #
#####################################

set -euo pipefail

###############################################################################
#   Runs on top of: archinstall minimal with the niri (waybar) profile.      #
#   archinstall already provides: niri, alacritty, fuzzel, mako, waybar,     #
#   swaybg, swayidle, swaylock, sddm, pipewire, nvidia drivers, linux-zen.   #
###############################################################################

NIRI_CONFIG="$HOME/.config/niri/config.kdl"

echo ":: ArchFassih setup for niri"

###############################################################################
#                        Install Noctalia shell                              #
###############################################################################
read -p "Install Noctalia shell and set up niri for it? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Installing noctalia"
    sudo pacman -S --noconfirm noctalia

    echo ":: Removing waybar, fuzzel, network-manager-applet (Noctalia replaces them)"
    sudo pacman -Rns --noconfirm waybar fuzzel network-manager-applet

    echo ":: Adding noctalia to niri config"
    mkdir -p "$(dirname "$NIRI_CONFIG")"
    if ! grep -q 'spawn-at-startup "noctalia"' "$NIRI_CONFIG" 2>/dev/null; then
        sed -i 's|// spawn-at-startup "noctalia"|spawn-at-startup "noctalia"|' "$NIRI_CONFIG"
        if ! grep -q 'spawn-at-startup "noctalia"' "$NIRI_CONFIG"; then
            printf '\nspawn-at-startup "noctalia"\n' >> "$NIRI_CONFIG"
        fi
    fi

    echo ":: Noctalia installed. Reboot or restart niri to apply."
fi

###############################################################################
#              Set up CachyOS repositories (mirrors + packages)              #
###############################################################################
read -p "Set up CachyOS repositories? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Downloading and running the CachyOS repo installer"
    cd /tmp
    curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
    tar xvf cachyos-repo.tar.xz
    cd cachyos-repo
    sudo ./cachyos-repo.sh

    echo ":: Syncing mirrors and updating all packages"
    sudo pacman -Syyu --noconfirm
fi

###############################################################################
#                         Set up Chaotic-AUR repository                      #
###############################################################################
read -p "Set up Chaotic-AUR repository? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Importing and trusting the Chaotic-AUR signing key"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB

    echo ":: Installing chaotic-keyring and chaotic-mirrorlist"
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    echo ":: Appending [chaotic-aur] to /etc/pacman.conf"
    if ! grep -q '\[chaotic-aur\]' /etc/pacman.conf; then
        printf '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' | sudo tee -a /etc/pacman.conf
    else
        echo ":: [chaotic-aur] already present, skipping"
    fi
fi

###############################################################################
#                     Install essential applications                          #
###############################################################################
read -p "Install essential applications? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Installing essential apps"
    sudo pacman -S --noconfirm fastfetch thunar zed opencode github-cli
    echo ":: Installing brave-origin-bin"
    sudo pacman -S --noconfirm brave-origin-bin
fi

###############################################################################
#                         Install utilities (archives, etc.)                  #
###############################################################################
read -p "Install utilities (ntfs-3g, archive tools, stow)? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Installing utilities"
    sudo pacman -S --noconfirm ntfs-3g thunar-archive-plugin xarchiver unrar unzip stow
fi

###############################################################################
#                              Install shell tools                            #
###############################################################################
read -p "Install shell tools (starship, fzf, zoxide, eza)? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Installing shell tools"
    sudo pacman -S --noconfirm starship fzf zoxide eza
fi

###############################################################################
#                               Install fonts                                 #
###############################################################################
read -p "Install fonts (jetbrains-mono-nerd)? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Installing fonts"
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
fi

###############################################################################
#                            GTK Theming (nwg-look)                           #
###############################################################################
read -p "Set up GTK theming (nwg-look, papirus, adw-gtk-theme)? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Installing GTK theming packages"
    sudo pacman -S --noconfirm nwg-look papirus-icon-theme adw-gtk-theme
    echo ":: Open nwg-look and set: adwaita-dark theme, JetBrains Mono Nerd Font as default,"
    echo ":: adwaita cursor, and Papirus-Dark icons."
    read -p "Launch nwg-look now? (y/n) " -r
    if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
        nwg-look
    fi
fi

###############################################################################
#                            QT Theming (qt5ct/qt6ct)                         #
###############################################################################
read -p "Set up QT theming (qt5ct, qt6ct, kvantum)? (y/n) " -r
if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    echo ":: Installing QT theming packages"
    sudo pacman -S --noconfirm qt5ct qt6ct kvantum

    echo ":: Setting QT_QPA_PLATFORMTHEME=qt6ct in ~/.bashrc"
    if ! grep -q 'QT_QPA_PLATFORMTHEME=qt6ct' "$HOME/.bashrc" 2>/dev/null; then
        printf '\nexport QT_QPA_PLATFORMTHEME=qt6ct\n' >> "$HOME/.bashrc"
    fi

    echo ":: Open qt6ct/qt5ct and set: Kvantum dark theme, JetBrains Mono font, Papirus-Dark icons."
    read -p "Launch qt6ct now? (y/n) " -r
    if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
        qt6ct
    fi
    read -p "Launch qt5ct now? (y/n) " -r
    if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
        qt5ct
    fi
fi

echo ":: Done. More sections coming soon."