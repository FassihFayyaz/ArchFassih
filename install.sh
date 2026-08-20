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

    echo ":: Removing waybar and fuzzel (Noctalia replaces them)"
    sudo pacman -Rns --noconfirm waybar fuzzel

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

echo ":: Done. More sections coming soon."