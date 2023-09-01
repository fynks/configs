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
function prompt() {
    local message="$1"
    printf "\n%s\n" "**********************************************"
    printf "%s\n" "$message"
    printf "%s\n\n" "**********************************************"
    read -r -p "Press Enter to continue..."
}

# Get the regular user's username
username=$(logname)

# Function to display a welcome message
function welcome() {
    local message="
    *Welcome "$username" to Arch Linux pre-Setup script.*
This script will:
    * Setup Chaotic-AUR and enable pacman parallel downloading
    * Invoke setup script to update mirrors and install packages
    * Setup hblock,Visual code studio for kde
    * Prompt if you want to disable extra services"
    local title="Welcome"
    local height=20
    local width=50
    whiptail --title "$title" --msgbox "$message" "$height" "$width" --ok-button "Continue" 0 0
}

# Welcome the user
welcome

# Prompt the user before launching browser
prompt "Opening Chaotic-AUR github page make sure to enable it."

# Open Chaotic-AUR GitHub page in default browser
sudo -u "$username" firefox "https://github.com/chaotic-aur" &
sleep 3

# Prompt the user before editing pacman config
prompt "Opening pacman config in nano,enable parallel downloading."

# Open pacman config in default text editor
sudo nano "/etc/pacman.conf"

# Prompt the user before initiating the setup script
prompt "This will initiate the setup script."

# Invoke the setup.sh script
echo "Initiating Setup script..."
sudo chmod +x "./setup.sh"
sudo "./setup.sh"
echo "Initialization successful."

exit 0
