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

# Copies the custom sources file from github to /etc/hblock/sources.list
 echo -e "\n##########################################\n######### Fixing VS Code for KDE #########\n##########################################\n"
 echo -e "Installing the required packages"
sudo pacman -S --needed --noconfirm gnome-keyring libsecret libgnome-keyring

 echo -e "copying the files to required directory"
 sudo  curl -o ~/.xinitrc 'https://raw.githubusercontent.com/fynks/configs/main/setup/sample_xinitrc_file'

echo -e "\n DONE  \n"
echo -e "\n open seahorse,unlock using password then Logout and login then login into github in VS Code \n"
exit 