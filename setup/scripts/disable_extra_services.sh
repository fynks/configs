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

# Disable and mask bluetooth service
printf "\n##################################################################################################\n#### Disabling and masking bluetooth service ####\n##################################################################################################\n"
sudo systemctl disable bluetooth.service
sudo systemctl mask bluetooth.service

# Disable and mask lvm2-monitor service
printf "\n##################################################################################################\n#### Disabling and masking lvm2-monitor service ####\n##################################################################################################\n"
sudo systemctl disable lvm2-monitor.service
sudo systemctl mask lvm2-monitor.service

# Stop,disable and mask docker service
printf "\n##################################################################################################\n#### Stopping,disabling and masking docker service ####\n##################################################################################################\n"
sudo systemctl stop docker.service
sudo systemctl disable docker.service
sudo systemctl mask docker.service

# Disable and mask ModemManager service
printf "\n##################################################################################################\n#### Disabling and masking ModemManager service####\n##################################################################################################\n"
sudo systemctl disable ModemManager.service
sudo systemctl mask ModemManager.service