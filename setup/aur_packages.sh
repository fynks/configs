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

# List of packages to be installed from Arch-AUR
AURPKGS=(
'librewolf-bin'           # Modified Firefox
'google-chrome'           # Chromium based Browser
'sublime-text-4'          # Lightweight Code Editor
'warpinator-git'          # File sharing with android
'converseen'              # Batch processing images
'visual-studio-code-bin'  # Code Editor
'ventoy-bin'              # Bootable USB flasher
'celluloid'               # MPV frontend
'android-tools'           # ADB tools
)

# Installs and names the package being installed by yay one by one
for AUR in "${AURPKGS[@]}"; do
 echo -e "\n############################################\n######### Program : $AUR #########\n############################################\n"
   yay -S --noconfirm $AUR
done

# Invokes the fish_config.sh script for fish shell setup
 echo -e "\n############################################\n######### Initiating Fish config  #########\n############################################\n"
echo "Initiation sucessfull"
sudo chmod +x "fish_config.sh"
./fish_config.sh