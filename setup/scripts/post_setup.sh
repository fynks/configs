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

echo -e "\n##########################################\n######### configuring hblock #########\n##########################################\n"

# Copies the custom sources file from GitHub to /etc/hblock/sources.list
echo -e "\n############################################\n######### Copying hblock sources file #########\n############################################\n"
sudo mkdir -p /etc/hblock/ &&
sudo curl -o /etc/hblock/sources.list 'https://raw.githubusercontent.com/fynks/configs/main/setup/configs/hblock_sources.list'

# Runs hblock and compiles the hosts file with custom sources
sudo hblock

echo -e "\n##########################################\n######### configuring VS Code #########\n##########################################\n"

# Fixing VS Code for KDE
echo -e "\n##########################################\n######### Fixing VS Code for KDE #########\n##########################################\n"
echo -e "Installing the required packages"
sudo pacman -S --needed --noconfirm gnome-keyring libsecret libgnome-keyring

echo -e "Copying the files to the required directory"
curl -o ~/.xinitrc 'https://raw.githubusercontent.com/fynks/configs/main/setup/configs/sample_xinitrc_file'

echo -e "\n DONE  \n"
echo -e "\n Open Seahorse, unlock using your password, then log out and log in again. After that, log in to GitHub in VS Code.\n"

echo -e "\n##########################################\n######### Setup Complete, please reboot #########\n##########################################\n"

exit
