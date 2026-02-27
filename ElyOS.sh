#!/bin/bash
set -e  # Exit immediately if any command fails

# ==============================
# Configuration
# ==============================
SCRIPT_NAME="ElyOS Installer"
SCRIPT_VERSION="0.0.3"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Logging Setup
LOG_FILE="/tmp/elyos_install_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== ElyOS Installer Log - $(date) ===" | tee -a "$LOG_FILE"

# Colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
PURPLE='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
NC='\e[0m' # No Color

# ==============================
# Helper Functions
# ==============================
print_header() {
    echo -e "${PURPLE}========================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${PURPLE}  $1${NC}" | tee -a "$LOG_FILE"
    echo -e "${PURPLE}========================================${NC}" | tee -a "$LOG_FILE"
}

print_step() {
    echo -e "\n${CYAN}>>> $1${NC}" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE" >&2
}

print_success() {
    echo -e "${GREEN}[OK] $1${NC}" | tee -a "$LOG_FILE"
}

print_warn() {
    echo -e "${YELLOW}[WARN] $1${NC}" | tee -a "$LOG_FILE"
}

# ==============================
# Pre-flight Checks
# ==============================
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "Do not run this script as root!"
        exit 1
    fi
}

check_internet() {
    if ! ping -c 1 archlinux.org &> /dev/null; then
        print_error "No internet connection! Please connect and try again."
        exit 1
    fi
}

check_arch() {
    if [ ! -f /etc/arch-release ]; then
        print_error "This script is designed for Arch Linux only!"
        exit 1
    fi
}

# ==============================
# ASCII Art Logo
# ==============================
show_logo() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
 ______  __      __  __  ______  ______  ______  ______  ______  ______   
/\  ___\/\ \    /\ \_\ \/\  __ \/\__  _\/\  == \/\  __ \/\  __ \/\  ___\  
\ \  __\\ \ \___\ \____ \ \  __ \/_/\ \/\ \  __<\ \  __ \ \ \/\ \ \___  \ 
 \ \_____\ \_____\/\_____\ \_\ \_\ \ \_\ \ \_\ \_\ \_\ \_\ \_____\/\_____\
  \/_____/\/_____/\/_____/\/_/\/_/  \/_/  \/_/ /_/\/_/\/_/\/_____/\/_____/
EOF
    echo -e "${PURPLE}${SCRIPT_NAME} - Version ${SCRIPT_VERSION}${NC}"
    echo ""
}

# ==============================
# Confirmation Prompt
# ==============================
confirm_install() {
    print_header "WARNING"
    echo -e "${RED}  This script will modify your system!${NC}"
    echo -e "${RED}  Only run on a FRESH minimal Arch install.${NC}"
    echo -e "${RED}  Make sure you have backups.${NC}"
    print_header "WARNING"
    echo -e "${WHITE}Do you want to continue with the ${SCRIPT_NAME} installation? (Y/n)${NC}"
    read -p ">> " answer

    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation aborted by user.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Starting installation...${NC}\n"
}

# ==============================
# Main Installation Steps
# ==============================
install_paru() {
    print_step "Step 1: Installing Paru AUR helper"
    sudo pacman -S --needed --noconfirm base-devel
    if [ ! -d "paru" ]; then
        git clone https://aur.archlinux.org/paru.git    
    fi
    cd paru
    makepkg -si --noconfirm
    cd ..
    print_success "Paru installed"
}

install_core_components() {
    print_step "Step 2: Installing core components"
    paru -S --needed --noconfirm wayfire wf-shell wayfire-plugins-extra kitty wofi lightdm lightdm-gtk-greeter
    sudo systemctl enable lightdm
    print_success "Core components installed"
}

setup_wayfire_config() {
    print_step "Step 3: Setting up Wayfire configuration [REQUIRED]"
    if [ -f "$SCRIPT_DIR/wayfire.ini" ]; then
        mkdir -p ~/.config/wayfire
        cp "$SCRIPT_DIR/wayfire.ini" ~/.config/wayfire/wayfire.ini
        print_success "Copied wayfire.ini"
    else
        print_error "wayfire.ini not found! This file is required."
        exit 1
    fi
}

install_thunar() {
    print_step "Step 4: Installing Thunar file manager"
    sudo pacman -S --needed --noconfirm thunar thunar-volman gvfs xfce4-settings
    print_success "Thunar installed"
}

install_audio_brightness() {
    print_step "Step 5: Audio/Brightness Dependencies"
    sudo pacman -S --needed --noconfirm alsa-lib alsa-firmware alsa-utils alsa-plugins alsa-tools brightnessctl
    paru -S --needed --noconfirm light
    sudo usermod -aG video "$USER"
    print_success "Audio/brightness tools installed"
}

setup_waybar() {
    print_step "Step 6: Setting up Waybar [OPTIONAL]"
    sudo pacman -S --needed --noconfirm waybar
    mkdir -p ~/.config/waybar
    if [ -f "$SCRIPT_DIR/config.jsonc" ]; then
        cp "$SCRIPT_DIR/config.jsonc" ~/.config/waybar/config.jsonc
        print_success "Copied waybar config"
    else
        print_warn "config.jsonc not found, waybar will use defaults"
    fi
}

setup_terminal_configs() {
    print_step "Step 7: Setting up terminal config [OPTIONAL]"
    mkdir -p ~/.config
    if [ -d "$SCRIPT_DIR/kitty" ]; then
        cp -r "$SCRIPT_DIR/kitty" ~/.config/
        print_success "Copied kitty config"
    elif [ -d "$SCRIPT_DIR/alacritty" ]; then
        cp -r "$SCRIPT_DIR/alacritty" ~/.config/
        print_success "Copied alacritty config"
    else
        print_warn "No terminal config folder (kitty/ or alacritty/), using defaults"
    fi
}

setup_wofi() {
    print_step "Step 8: Setting up Wofi configuration [OPTIONAL]"
    if [ -d "$SCRIPT_DIR/wofi" ]; then
        mkdir -p ~/.config
        cp -r "$SCRIPT_DIR/wofi" ~/.config/
        print_success "Copied wofi config"
    else
        print_warn "wofi/ folder not found, using default wofi settings"
    fi
}

setup_bin_scripts() {
    print_step "Step 9: Installing utility scripts [OPTIONAL]"
    if [ -d "$SCRIPT_DIR/bin" ] && ls "$SCRIPT_DIR/bin"/*.sh &> /dev/null; then
        mkdir -p ~/.local/bin
        cp "$SCRIPT_DIR/bin/"*.sh ~/.local/bin/
        chmod +x ~/.local/bin/*.sh
        print_success "Copied utility scripts to ~/.local/bin"
    else
        print_warn "bin/ folder or scripts not found, skipping"
    fi
}

install_misc() {
    print_step "Step 10: Installing miscellaneous packages"
    sudo pacman -S --needed --noconfirm firefox fastfetch sof-firmware ttf-roboto-mono wl-clipboard
    print_success "Miscellaneous packages installed"
}

setup_wallpaper() {
    print_step "Step 11: Setting up wallpaper with swaybg"
    # Install swaybg
    sudo pacman -S --needed --noconfirm swaybg
    print_success "swaybg installed"
    
    # Create wallpaper directory
    mkdir -p ~/Pictures/wallpapers
    
    # Copy wallpaper from repo if it exists
    if [ -d "$SCRIPT_DIR/wallpapers" ] && ls "$SCRIPT_DIR/wallpapers/"* &> /dev/null; then
        cp "$SCRIPT_DIR/wallpapers/"* ~/Pictures/wallpapers/
        print_success "Wallpaper copied to ~/Pictures/wallpapers/"
    else
        print_warn "No wallpapers found in repo, you'll need to set one manually"
    fi
    
    print_success "Wallpaper setup complete"
}

# ==============================
# Completion & Reboot
# ==============================
show_completion() {
    clear
    print_header "INSTALLATION COMPLETE"
    echo -e "${GREEN}✓ ${SCRIPT_NAME} has been installed successfully!${NC}\n" | tee -a "$LOG_FILE"
    echo "Remember to:"
    echo -e "  1. ${PURPLE}Reboot your system${NC}"
    echo -e "  2. ${PURPLE}Select 'Wayfire' session at the LightDM login screen${NC}\n"
    echo -e "${GREEN}=== Installation log saved to: ${LOG_FILE} ===${NC}"
    echo -e "${YELLOW}If you encountered errors, share this log for debugging.${NC}\n"
    
    echo -e "${WHITE}Do you want to reboot the system now? (Y/n)${NC}"
    read -p ">> " reboot_answer

    if [[ "$reboot_answer" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Rebooting system...${NC}"
        sudo reboot
    else
        echo -e "${YELLOW}Reboot skipped. Please reboot manually when ready.${NC}"
    fi
}

# ==============================
# Main Execution
# ==============================
main() {
    # Handle --version flag
    if [[ "$1" == "--version" || "$1" == "-v" ]]; then
        echo "${SCRIPT_NAME} v${SCRIPT_VERSION}"
        exit 0
    fi

    show_logo
    check_root
    check_arch
    check_internet
    confirm_install
    
    install_paru
    install_core_components
    setup_wayfire_config
    install_thunar
    install_audio_brightness
    setup_waybar
    setup_terminal_configs
    setup_wofi
    setup_bin_scripts
    install_misc
    setup_wallpaper
    
    show_completion
}

# Run main function with all arguments
main "$@"
