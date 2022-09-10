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


# Color Configs
GREEN="\e[32"
YELLOW="\e[33"
BLUE="\e[34"
BOLDGREEN="\e[1;${GREEN}m"
ITALICGREEN="\e[3;${GREEN}m"
ITALICYELLOW="\e[3;${YELLOW}m"
ITALICBLUE="\e[3;${BLUE}m"
ENDCOLOR="\e[0m"

# Copies the custom sources file from github to /etc/hblock/sources.list
 echo -e "\n##########################################\n######### Fixing VS Code for KDE #########\n##########################################\n"
 echo -e ">> ${ITALICGREEN}Installing the required packages${ENDCOLOR} <<"
sudo pacman -S --noconfirm gnome-keyring libsecret libgnome-keyring

 echo -e ">> ${ITALICGREEN}copying the files to required directory${ENDCOLOR} <<"
 sudo  curl -o ~/.xinitrc 'https://raw.githubusercontent.com/fynks/configs/main/setup/sample_xinitrc_file'

echo -e "\n >> ${ITALICBLUE}DONE ${ENDCOLOR} << \n"
echo -e "\n >> ${ITALICYELLOW}open seahorse,unlock using password then Logout and login then login into github in VS Code ${ENDCOLOR} << \n"
exit 
