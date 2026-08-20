#!/bin/bash
#####################################
#    Created by Fassih Fayyaz       #
#####################################
# Migrates the ESP mount point from /boot/efi to /boot (archinstall standard).
# Run with sudo. Reversible via the printed rollback steps.

set -euo pipefail

ESP_UUID="3D21-4286"

echo "== Backing up /etc/fstab"
sudo cp /etc/fstab /etc/fstab.bak-esp-migrate

echo "== Moving current ext4 /boot files aside (they are hidden once the ESP is mounted at /boot)"
sudo mkdir -p /root/boot-ext4-backup
sudo mv /boot/vmlinuz-* /boot/initramfs-* /boot/amd-ucode.img /root/boot-ext4-backup/ 2>/dev/null || true
ls -la /boot/

echo "== Updating /etc/fstab: /boot/efi -> /boot"
sudo sed -i "s|UUID=${ESP_UUID}[[:space:]]*/boot/efi|UUID=${ESP_UUID}\t/boot|" /etc/fstab
grep "$ESP_UUID" /etc/fstab

echo "== Removing archinstall's 99-limine.hook (hardcodes /boot/efi; limine-install handles deployment)"
sudo rm -f /etc/pacman.d/hooks/99-limine.hook

echo "== Updating linux-zen mkinitcpio preset: /boot/efi/EFI/Linux -> /boot/EFI/Linux"
sudo sed -i 's|/boot/efi/EFI/Linux|/boot/EFI/Linux|g' /etc/mkinitcpio.d/linux-zen.preset

echo "== Removing stale limine configs from the ESP (conflicting with the hook-managed /boot/limine.conf)"
sudo rm -f /boot/efi/EFI/BOOT/limine.conf /boot/efi/EFI/limine/limine.conf 2>/dev/null || true

echo "== Switching mount: unmount /boot/efi, remove mountpoint dir, mount ESP at /boot"
sudo umount /boot/efi
sudo rmdir /boot/efi
sudo mount /boot

echo "== Verifying new layout"
findmnt /boot
df -h /boot

echo "== Regenerating limine boot entries for all kernels"
sudo limine-mkinitcpio

echo ""
echo "== DONE. Reboot to test. =="
echo ""
echo "ROLLBACK (if boot fails, boot archiso and):"
echo "  mount root, then: cp /etc/fstab.bak-esp-migrate /mnt/etc/fstab"
echo "  mkdir -p /mnt/boot/efi && mount --bind ...  (or re-mount ESP at /boot/efi)"
echo "  Move /root/boot-ext4-backup/* back to /boot"