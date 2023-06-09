#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   ______ __     __ _   _  _  __  _____ 
# |  ____|\ \   / /| \ | || |/ / / ____|
# | |__    \ \_/ / |  \| || ' / | (___  
# |  __|    \   /  | . ` ||  <   \___ \ 
# | |        | |   | |\  || . \  ____) |
# |_|        |_|   |_| \_||_|\_\|_____/ 
#                                       
#  Arch Linux Pre-Setup script
#-------------------------------------------------------------------------

# Check if user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Get the regular user's username
username=$(logname)

echo -e "\n##################################################################################################\n#### Launching chaotic AUR in Firefox browser. Please enable the Chaotic AUR and pacman parallel downloading.####\n##################################################################################################\n"
sleep 3

# Opens Chaotic-AUR github page
sudo -u "$username" firefox "https://github.com/chaotic-aur" &

# Open pacman config in nano to enable parallel downloading
sudo nano /etc/pacman.conf
sleep 1

# Invoke the setup.sh script to initiate the setup
echo -e "\n############################################\n######### Initiating Setup script #########\n############################################\n"
sleep 3
sudo chmod +x "setup.sh"
sudo ./setup.sh
echo "Initialization successful"

exit 0
