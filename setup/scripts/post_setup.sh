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

# Function to print section headers
print_section_header() {
    printf "\n############################################\n"
    printf "######### %s #########\n" "$1"
    printf "############################################\n\n"
}

# Function to install packages if missing
install_packages_if_needed() {
    for pkg in "$@"; do
        if ! pacman -Q "$pkg" &> /dev/null; then
            sudo pacman -S --needed --noconfirm "$pkg"
        fi
    done
}

# Copies the custom sources file from GitHub to /etc/hblock/sources.list
print_section_header "configuring hblock"
sudo mkdir -p /etc/hblock/ &&
sudo curl -o /etc/hblock/sources.list 'https://raw.githubusercontent.com/fynks/configs/main/setup/configs/hblock_sources.list'
sudo hblock

# Enables docker service
print_section_header "Enabling docker-service"
sudo systemctl start docker.service
sudo systemctl enable docker.service

# Fixing VS Code for KDE
print_section_header "Fixing VS Code for KDE"
install_packages_if_needed gnome-keyring libsecret libgnome-keyring
echo -e "Copying the files to the required directory"
curl -o ~/.xinitrc 'https://raw.githubusercontent.com/fynks/configs/main/setup/configs/sample_xinitrc_file'
echo -e "\n DONE  \n"
echo -e "\n Open Seahorse, unlock using your password, then log out and log in again. After that, log in to GitHub in VS Code.\n"

print_section_header "Setup Complete, please reboot"
exit