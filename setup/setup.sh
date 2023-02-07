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
echo "changing branch and Updating mirrors with fastest mirrors"
sudo pacman-mirrors --api --set-branch unstable
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
'alacritty'               # GPU accelerated terminal
'fish'                    # Fish shell
'plasma-wayland-session'  # Plasma Wayland
'firefox'                 # Browser
'nemo'                    # File manager
'vlc'                     # Media Player
'evince'                  # pdf Viewer
'bleachbit'               # Cleaner utility
'nodejs'                  # Javascript engine
'npm'                     # Node package manager
'appimagelauncher'        # Integrates AppImages into system
'telegram-desktop'        # Social platform
'simplescreenrecorder'    # Screen Recorder
'gimp'                    # Advanced photo editor
)

# Installs and names the package being installed by pacman one by one
for PACMAN in "${PACMANPKGS[@]}"; do
 echo -e "\n############################################\n######### Program : $PACMAN #########\n############################################\n"
   sudo pacman --needed --noconfirm -S $PACMAN
done

# Installs hblock
 echo -e "\n############################################\n######### Installing Hblock #########\n############################################\n"
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.4.1/hblock' \
  && echo 'bb1f6fcafdcba6f7bd9e12613fc92b02a0a0da1263b0e44d209cb40d8715d647  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown 0:0 /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock

# Copies the custom sources file from github to /etc/hblock/sources.list
 echo -e "\n############################################\n######### Copying hblock sources file  #########\n############################################\n"
sudo mkdir /etc/hblock/ && sudo  curl -o /etc/hblock/sources.list 'https://raw.githubusercontent.com/fynks/configs/main/setup/hblock_sources.list'

# Runs hblock and compiles the hosts file with custom sources
sudo hblock

# Invokes the aur_packages.sh script for installing extra packages form AUR
 echo -e "\n############################################\n######### Initiating installing packages from AUR  #########\n############################################\n"
echo "Script launch successful"
sudo chmod +x "aur_packages.sh"
./aur_packages.sh

exit 
