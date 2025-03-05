#!/bin/bash
set -e  # Exit immediately if any command fails

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Step 1: Install Paru AUR helper ==="
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si  # You'll need to confirm the installation manually
cd ..

echo "=== Step 2: Install core components ==="
paru -S wayfire wf-shell wayfire-plugins-extra alacritty wofi lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

echo "=== Step 3: Setup Wayfire configuration ==="
# Use the existing config from this repository instead of cloning
if [ -f "$SCRIPT_DIR/wayfire.ini" ]; then
    mkdir -p ~/.config
    cp "$SCRIPT_DIR/wayfire.ini" ~/.config/wayfire.ini
    echo "Copied wayfire.ini from local repository"
else
    echo "ERROR: wayfire.ini not found in repository directory!"
    exit 1
fi

echo "=== Step 4: Install Thunar file manager ==="
sudo pacman -S --needed thunar thunar-volman gvfs xfce4-settings

echo "=== Installation complete! ==="
echo "Remember to:"
echo "1. Reboot your system"
echo "2. Select Wayfire session on login"
echo "3. Configure your display manager if needed"