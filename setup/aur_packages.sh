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

# Installing packages using yay
AURPKGS=(
'alacritty'               # GPU accelerated terminal
'fish'                    # Fish shell
'plasma-wayland-session'  # Plasma Wayland
'firefox'                 # Browser
'librewolf-bin'           # Modified Firefox
'nemo'                    # File manager
'vlc'                     # Media Player
'evince'                  # pdf Viewer
'bleachbit'               # Cleaner utility
'sublime-text-4'          # Lightweight Code Editor
'visual-studio-code-bin'  # Code Editor
'libreoffice-fresh'       # Libre Office suit
'nodejs'                  # Javascript engine
'npm'                     # Node package manager
'android-tools'           # ADB tools
'tor-browser'             # Tor Browser
'ventoy-bin'              # Bootable USB flasher
'google-chrome'           # Chromium based Browser
'appimagelauncher'        # Integrates AppImages into system
'telegram-desktop'        # Social platform
'simplescreenrecorder'    # Screen Recorder
'warpinator-git'          # File sharing with android
'converseen'              # Batch processing images
'celluloid'               # MPV frontend
'gimp'                    # Advanced photo editor
)

# Installs and names the package being installed by yay one by one
for AUR in "${AURPKGS[@]}"; do
 echo -e "\n############################################\n######### Program : $AUR #########\n############################################\n"
   yay --needed --noconfirm -S $AUR
done

# Invokes the fish_config.sh script for fish shell setup
 echo -e "\n############################################\n######### Initiating Fish config  #########\n############################################\n"
echo "Initiation sucessfull"
sudo chmod +x "fish_config.sh"
./fish_config.sh