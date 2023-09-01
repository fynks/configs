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

# Function to display a highlighted prompt and ask for user confirmation
function prompt() {
    local message="$1"
    whiptail --title "Confirmation" --yesno "$message 
    Do you want to continue?" 10 50
    return $?
}

# Get the regular user's username
username=$(logname)

# Function to display a welcome message and ask for user confirmation
function welcome() {
    local message="
    *Welcome "$username" to Arch Linux pre-Setup script.*
This script will:
    * Setup Chaotic-AUR and enable pacman parallel downloading
    * Invoke setup script to update mirrors and install packages
    * Setup hblock,Visual code studio for KDE
    * Prompt if you want to disable extra services"
    whiptail --title "Welcome" --msgbox "$message" 20 50 --ok-button "continue"
    return $?
}

# Welcome the user and ask for confirmation
welcome || exit 0

# Open Chaotic-AUR GitHub page in default browser
prompt "Opening Chaotic-AUR GitHub page. Make sure to enable it." || exit 0
sudo -u "$username" firefox "https://github.com/chaotic-aur" &
sleep 3

# Prompt the user before editing pacman config
prompt "Opening pacman config in nano to enable parallel downloading." || exit 0
sudo nano "/etc/pacman.conf"

# Prompt the user before initiating the setup script
prompt "This will initiate the setup script." || exit 0
echo "Initiating Setup script..."
sudo chmod +x "./setup.sh"
sudo "./setup.sh"
echo "Initialization successful."

exit 0
