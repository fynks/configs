#!/usr/bin/env bash
#-------------------------------------------------------------------------
#    ______ __     __ _   _  _  __  _____
#  |  ____|\ \   / /| \ | || |/ / / ____|
#  | |__    \ \_/ / |  \| || ' / | (___
#  |  __|    \   /  | . ` ||  <   \___ \
#  | |        | |   | |\  || . \  ____) |
#  |_|        |_|   |_| \_||_|\_\|_____/
#
#  Arch Linux Pre-Setup script
#-------------------------------------------------------------------------

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi
# Function to display a highlighted prompt
prompt() {
    printf "\n%s\n" "**********************************************"
    printf "%s\n" "$1"
    printf "%s\n\n" "**********************************************"
    read -p "Press Enter to continue..."
}

# Get the regular user's username
username=$(logname)

# Prompt the user before launching browser
prompt "This will open Chaotic-AUR GitHub page in firefox.Make sure to enable Chaotic-AUR and pacman parallel downloading."

# Open Chaotic-AUR GitHub page in default browser
sudo -u "$username" firefox "https://github.com/chaotic-aur" &
sleep 3

# Prompt the user before editing pacman config
prompt "This will open pacman config in nano text editor.Make sure to enable parallel downloading."

# Open pacman config in default text editor
sudo nano /etc/pacman.conf

# Prompt the user before initiating the setup script
prompt "This will initiate the setup script."
# Invoke the setup.sh script
setup_script="./setup.sh"
if [ ! -f "$setup_script" ]; then
    echo "Error: $setup_script not found."
    exit 1
fi

echo "Initiating Setup script..."
sudo chmod +x "$setup_script"
sudo "./$setup_script"
echo "Initialization successful."

exit 0
