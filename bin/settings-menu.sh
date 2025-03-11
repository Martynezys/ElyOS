#!/bin/bash

# Define menu options
options="Launch application\nConnect to wifi"

# Use wofi to display the menu
choice=$(echo -e "$options" | wofi --dmenu --prompt="Settings Menu")

# Execute the corresponding action based on the choice
case "$choice" in
    "Launch application")
        wofi --show drun
        ;;
    "Connect to wifi")
        ~/.local/bin/wifi-connect.sh
        ;;
esac
