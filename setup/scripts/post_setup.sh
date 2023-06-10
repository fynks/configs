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

# Installs hblock
echo -e "\n############################################\n######### Installing Hblock #########\n############################################\n"
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.4.2/hblock' &&
echo 'a7d748b69db9f94932333a5b5f0c986dd60a39fdf4fe675ad58364fea59c74b4  /tmp/hblock' | shasum -c &&
sudo mv /tmp/hblock /usr/local/bin/hblock &&
sudo chown 0:0 /usr/local/bin/hblock &&
sudo chmod 755 /usr/local/bin/hblock

# Copies the custom sources file from GitHub to /etc/hblock/sources.list
echo -e "\n############################################\n######### Copying hblock sources file #########\n############################################\n"
sudo mkdir -p /etc/hblock/ &&
sudo curl -o /etc/hblock/sources.list 'https://raw.githubusercontent.com/fynks/configs/main/setup/hblock_sources.list'

# Runs hblock and compiles the hosts file with custom sources
sudo hblock

# Fixing VS Code for KDE
echo -e "\n##########################################\n######### Fixing VS Code for KDE #########\n##########################################\n"
echo -e "Installing the required packages"
sudo pacman -S --needed --noconfirm gnome-keyring libsecret libgnome-keyring

echo -e "Copying the files to the required directory"
curl -o ~/.xinitrc 'https://raw.githubusercontent.com/fynks/configs/main/setup/sample_xinitrc_file'

echo -e "\n DONE  \n"
echo -e "\n Open Seahorse, unlock using your password, then log out and log in again. After that, log in to GitHub in VS Code.\n"

echo -e "\n##########################################\n######### Setup Complete, please reboot #########\n##########################################\n"

exit
