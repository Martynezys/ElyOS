#!/bin/bash
set -e  # Exit immediately if any command fails

clear

# ==============================
# ASCII Art Logo
# ==============================
echo -e "\e[35m"
cat << "EOF"
 ______  __      __  __  ______  ______  ______  ______  ______  ______   
/\  ___\/\ \    /\ \_\ \/\  __ \/\__  _\/\  == \/\  __ \/\  __ \/\  ___\  
\ \  __\\ \ \___\ \____ \ \  __ \/_/\ \/\ \  __<\ \  __ \ \ \/\ \ \___  \ 
 \ \_____\ \_____\/\_____\ \_\ \_\ \ \_\ \ \_\ \_\ \_\ \_\ \_____\/\_____\
  \/_____/\/_____/\/_____/\/_/\/_/  \/_/  \/_/ /_/\/_/\/_/\/_____/\/_____/

EOF

# ==============================
# Confirmation Prompt
# ==============================
echo -e "\e[35mElyatraOS Install Script - Version 0.0.1\e[0m"
echo -e "\e[37mDo you want to continue with the ElyatraOS installation? (Y/n)\e[0m"
read -p ">> " answer

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo -e "\e[31mInstallation aborted by user.\e[0m"
    exit 1
fi

# ==============================
# Script Execution
# ==============================
echo -e "\e[32mStarting installation...\e[0m"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"


# ==============================
# Step 0: pacman confirm
# ==============================
sudo pacman -S --needed --noconfirm fastfetch


# ==============================
# Step 1: Install Paru AUR Helper
# ==============================
echo -e "\e[35m=== Step 1: Installing Paru AUR helper ===\e[0m"
sudo pacman -S --needed --noconfirm base-devel
if [ ! -d "paru" ]; then
    git clone https://aur.archlinux.org/paru.git
fi
cd paru
makepkg -si --noconfirm
cd ..

# ==============================
# Step 2: Install Core Components
# ==============================
echo -e "\e[35m=== Step 2: Installing core components ===\e[0m"
paru -S --needed --noconfirm wayfire wf-shell wayfire-plugins-extra alacritty wofi lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

# ==============================
# Step 3: Setup Wayfire Configuration
# ==============================
echo -e "\e[35m=== Step 3: Setting up Wayfire configuration ===\e[0m"
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
echo -e "\e[35m=== Step 4: Installing Thunar file manager ===\e[0m"
sudo pacman -S --needed --noconfirm thunar thunar-volman gvfs xfce4-settings

# ==============================
# Step 5: Volume/Brightness Dependancies
# ==============================
echo -e "\e[35m=== Step 5: Volume/Brightness Dependancies ===\e[0m"
sudo pacman -S --needed --noconfirm alsa-lib alsa-firmware alsa-utils alsa-plugins alsa-tools brightnessctl
paru -S --needed --noconfirm light
sudo usermod -aG video $USER

# ==============================
# Step 6: Waybar
# ==============================
echo -e "\e[35m=== Step 6: Waybar ===\e[0m"
sudo pacman -S --needed --noconfirm waybar
mkdir -p ~/.config/waybar
if [ -f "$SCRIPT_DIR/config.jsonc" ]; then
    cp "$SCRIPT_DIR/config.jsonc" ~/.config/waybar/config.jsonc
    echo "Copied config.jsonc from local repository"
else
    echo -e "\e[31mERROR: config.jsonc not found in repository directory!\e[0m"
    exit 1
fi

# ==============================
# Step 7: miscellaneous
# ==============================
echo -e "\e[35m=== Step 7: miscellaneous ===\e[0m"
sudo pacman -S --needed --noconfirm firefox

# ==============================
# Completion Message
# ==============================
clear
echo -e "\e[32m=== Installation complete! ===\e[0m"
echo "Remember to:"
echo -e "1. \e[35mReboot your system\e[0m"
echo "2. Select Wayfire session on login"

# ==============================
# Reboot Prompt
# ==============================
echo -e "\e[37mDo you want to reboot the system now? (Y/n)\e[0m"
read -p ">> " reboot_answer

if [[ "$reboot_answer" =~ ^[Yy]$ ]]; then
    echo -e "\e[32mRebooting system...\e[0m"
    sudo reboot
else
    echo -e "\e[33mReboot skipped. Please remember to reboot manually and select Wayfire session.\e[0m"
fi
