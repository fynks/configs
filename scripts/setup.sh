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
echo -e "\n############################################\n######### Pacman mirrors and databases updates #########\n############################################\n"
echo "Updating mirrors with fastest mirrors"
sudo pacman-mirrors --fasttrack 20

echo "\nSyncing databases \n"
sudo pacman -Syyuu

# Start of installing packges
echo -e "\n############################################\n######### Starting installing packages #########\n############################################\n"

# List of packages to be installed from pacman
PACMANPKGS=(
'base-devel'              # Base Developement package
'cmake'                   # Required for various pakage compililations
'yay'                     # AUR Helper
'alacritty'               # GPU accelerated terminal
'fish'                    # Fish shell
'firefox'                 # Browser
'nemo'                    # File manager
'vlc'                     # Media Player
'evince'                  # pdf Viewer
'bleachbit'               # Cleaner utility
'nodejs'                  # Javascript engine
'appimagelauncher'        # Integrates AppImages into system
'telegram-desktop'        # Social platform
'simplescreenrecorder'    # Screen Recorder
)

# Installs and names the package being installed by pacman one by one
for PACMAN in "${PACMANPKGS[@]}"; do
 echo -e "\n############################################\n######### Program : $PACMAN #########\n############################################\n"
   sudo pacman -S $PACMAN
done

# List of packages to be installed from Arch-AUR
AURPKGS=(
'librewolf-bin'           # Modified Firefox
'brave-bin'               # Chromium based Browser
'sublime-text-4'          # Lightweight Code Editor
'warpinator-git'          # File sharing with android
'converseen'              # Batch processing images
'visual-studio-code-bin'  # Code Editor
'ventoy-bin'              # Bootable USB flasher
'input-remapper-git'      # Custom remap the mouse
'zoom'                    # Video conferencing tool
'qnapi-git'               # Subtitles downloader
)

# Installs and names the package being installed by yay one by one
for AUR in "${AURPKGS[@]}"; do
 echo -e "\n############################################\n######### Program : $AUR #########\n############################################\n"
   sudo yay -S $AUR
done

# Installs hblock
 echo -e "\n############################################\n######### Installing Hblock #########\n############################################\n"
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.4.0/hblock' \
  && echo '4031d86cd04fd7c6cb1b7e9acb1ffdbe9a3f84f693bfb287c68e1f1fa2c14c3b  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown 0:0 /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock

# Copies the custom sources file from github to /etc/hblock/sources.list
 echo -e "\n############################################\n######### Copying hblock sources file  #########\n############################################\n"
sudo mkdir /etc/hblock/ && sudo  curl -o /etc/hblock/sources.list 'https://raw.githubusercontent.com/fynks/configs/main/prefs/hblock-sources/sources.list'

# Runs hblock and compiles the hosts file with custom sources
sudo hblock


echo -e "\n############################################\n######### DONE #########\n############################################\n"
exit 
