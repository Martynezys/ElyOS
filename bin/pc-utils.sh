#!/bin/bash

# Suppress GTK warnings
export GDK_BACKEND=wayland
exec 2>/dev/null

# Define menu options
options="Lock Screen\nLog Out\nRestart\nShutdown\nSuspend\nHibernate"

# Use wofi to display the menu
choice=$(echo -e "$options" | wofi --dmenu --prompt="Power Options")

# Execute the corresponding action based on the choice
case "$choice" in
    "Lock Screen")
        dm-tool lock
        ;;
    "Log Out")
        dm-tool switch-to-greeter
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Hibernate")
        systemctl hibernate
        ;;
esac
