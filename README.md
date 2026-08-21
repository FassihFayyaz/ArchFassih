# My Arch Linux Setup Installation Script

Script to take a fresh `archinstall` minimal install (niri profile) up to my working niri + Noctalia setup.

## Baseline: what archinstall already sets up

1. Run `archinstall` with the **niri (waybar)** profile.
2. During archinstall, select:
   - NVIDIA drivers
   - `sddm` as display manager
   - `pipewire` for audio
   - `linux-zen` as kernel
   - All fonts **except** `noto-cjk`
3. The niri profile installs: `niri`, `alacritty`, `fuzzel`, `mako`, `xorg-xwayland`, `waybar`, `swaybg`, `swayidle`, `swaylock`, `xdg-desktop-portal-gnome`.
4. **Limine** is chosen as the bootloader (not systemd-boot or GRUB).

After first boot the script takes over.

## Current status

- [x] Install Noctalia shell and configure niri to use it (removes `waybar` + `fuzzel`)
- [x] Install CachyOS repos and CachyOS kernel
- [x] Install Chaotic-AUR
- [x] Install essential apps
- [x] Install utilities and shell tools
- [x] Install fonts, GTK/QT theming, gaming packages
- [ ] More steps coming...

## Dotfiles

Dotfiles live in a separate repo: [FassihFayyaz/dotfiles](https://github.com/FassihFayyaz/dotfiles).

After cloning, symlink everything into your home directory with GNU Stow:

```bash
git clone https://github.com/FassihFayyaz/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -t ~ */
```

## Usage

```bash
git clone https://github.com/fassihfayyaz/archfassih.git
cd archfassih
chmod +x install.sh
./install.sh
```