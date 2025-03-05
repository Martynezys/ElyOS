#!/bin/bash
set -e  # Exit immediately if any command fails

# ==============================
# Script Metadata
# ==============================
VERSION="0.0.1"

# Display version information in purple
echo -e "\e[35mElyatraOS Install Script - Version $VERSION\e[0m"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ==============================
# Step 1: Install Paru AUR Helper
# ==============================
echo "=== Step 1: Installing Paru AUR helper ==="
sudo pacman -S --needed base-devel
if [ ! -d "paru" ]; then
    git clone https://aur.archlinux.org/paru.git
fi
cd paru
makepkg -si --noconfirm  # Automatically confirm prompts
cd ..

# ==============================
# Step 2: Install Core Components
# ==============================
echo "=== Step 2: Installing core components ==="
paru -S --needed --noconfirm wayfire wf-shell wayfire-plugins-extra alacritty wofi lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

# ==============================
# Step 3: Setup Wayfire Configuration
# ==============================
echo "=== Step 3: Setting up Wayfire configuration ==="
if [ -f "$SCRIPT_DIR/wayfire.ini" ]; then
    mkdir -p ~/.config
    cp "$SCRIPT_DIR/wayfire.ini" ~/.config/wayfire.ini
    echo "Copied wayfire.ini from local repository"
else
    echo -e "\e[31mERROR: wayfire.ini not found in repository directory!\e[0m"
    exit 1
fi

# ==============================
# Step 4: Install Thunar File Manager
# ==============================
echo "=== Step 4: Installing Thunar file manager ==="
sudo pacman -S --needed --noconfirm thunar thunar-volman gvfs xfce4-settings

# ==============================
# Completion Message
# ==============================
echo -e "\e[32m=== Installation complete! ===\e[0m"
echo "Remember to:"
echo "1. Reboot your system"
echo "2. Select Wayfire session on login"
echo "3. Configure your display manager if needed"