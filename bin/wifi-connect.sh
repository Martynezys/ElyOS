i#!/bin/bash

# Suppress GTK warnings
export GDK_BACKEND=wayland
exec 2>/dev/null

# List available Wi-Fi networks with SSID and SECURITY fields
networks=$(nmcli --fields "SSID,SECURITY" --terse dev wifi | awk -F':' '{print $1 " (" $2 ")"}')

# Use wofi to select a network
chosen_network=$(echo "$networks" | wofi --dmenu --prompt="Select Wi-Fi Network")

# Check if a network was selected
if [ -n "$chosen_network" ]; then
    # Extract the SSID (removing the security info in parentheses)
    ssid=$(echo "$chosen_network" | sed 's/ (.*$//')
    
    # Extract the security type
    security=$(echo "$chosen_network" | sed 's/^.*(\(.*\))$/\1/')
    
    # Debug: Print the extracted SSID and security type
    echo "Selected SSID: $ssid"
    echo "Security type: $security"
    
    # Check if the network is secured
    if [[ "$security" == *"WPA"* || "$security" == *"WEP"* ]]; then
        # Prompt for a password using wofi
        password=$(wofi --dmenu --password --prompt="Enter Wi-Fi Password")
        
        # Check if a password was entered
        if [ -n "$password" ]; then
            # Connect to the network with the provided password
            nmcli dev wifi connect "$ssid" password "$password"
        else
            echo "No password entered. Aborting connection."
        fi
    else
        # Connect to open networks without a password
        nmcli dev wifi connect "$ssid"
    fi
fi
