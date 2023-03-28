#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   ______ __     __ _   _  _  __  _____ 
# |  ____|\ \   / /| \ | || |/ / / ____|
# | |__    \ \_/ / |  \| || ' / | (___  
# |  __|    \   /  | . ` ||  <   \___ \ 
# | |        | |   | |\  || . \  ____) |
# |_|        |_|   |_| \_||_|\_\|_____/ 
#                                       
#  Arch Linux Post Install Setup and Config Script
#-------------------------------------------------------------------------

# Updates the mirrors and force refreshes the repository databases
echo -e "\n############################################\n######### Pacman Branch,mirrors and databases updates #########\n############################################\n"
echo "Updating mirrors with fastest mirrors"
sudo pacman-mirrors --fasttrack 10

echo "\nSyncing databases \n"
sudo pacman -Syu

# Start of installing packges
echo -e "\n############################################\n######### Starting installing packages #########\n############################################\n"

# List of packages to be installed from pacman
PACMANPKGS=(
'base-devel'              # Base Developement package
'cmake'                   # Required for various pakage compililations
'yay'                     # AUR Helper
)

# Installs and names the package being installed by pacman one by one
for PACMAN in "${PACMANPKGS[@]}"; do
 echo -e "\n############################################\n######### Program : $PACMAN #########\n############################################\n"
   sudo pacman --needed --noconfirm -S $PACMAN
done

# Invokes the aur_packages.sh script for installing extra packages form AUR
 echo -e "\n############################################\n######### Initiating installing packages from AUR  #########\n############################################\n"
echo "Script launch successful"
sudo chmod +x "aur_packages.sh"
./aur_packages.sh

exit 
