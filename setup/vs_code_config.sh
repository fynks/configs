#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   ______ __     __ _   _  _  __  _____ 
# |  ____|\ \   / /| \ | || |/ / / ____|
# | |__    \ \_/ / |  \| || ' / | (___  
# |  __|    \   /  | . ` ||  <   \___ \ 
# | |        | |   | |\  || . \  ____) |
# |_|        |_|   |_| \_||_|\_\|_____/ 
#                                       
#  VS Code fix for KDE Linux
#-------------------------------------------------------------------------

# Copies the custom sources file from github to /etc/hblock/sources.list
 echo -e "\n##########################################\n######### Fixing VS Code for KDE #########\n##########################################\n"
 echo -e "Installing the required packages"
sudo pacman -S --noconfirm gnome-keyring libsecret libgnome-keyring

 echo -e "copying the files to required directory"
 sudo  curl -o ~/.xinitrc 'https://raw.githubusercontent.com/fynks/configs/main/setup/sample_xinitrc_file'

echo -e "\n DONE  \n"
echo -e "\n open seahorse,unlock using password then Logout and login then login into github in VS Code \n"
exit 
