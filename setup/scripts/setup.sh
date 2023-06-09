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

# Check if user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Updates the mirrors
echo -e "\n############################################\n######### Pacman Branch,mirrors and databases updates #########\n############################################\n"
echo "Updating mirrors with fastest mirrors"
if ! sudo pacman-mirrors --fasttrack 10; then
    echo "Error updating mirrors. Aborting."
    exit 1
fi

# Syncs the detabases
echo -e "\nSyncing databases\n"
sudo pacman -Syu

# Install yay if not installed
echo -e "\nChecking if yay is available\n"
if ! pacman -Qs yay > /dev/null; then
    echo "yay is not installed. Installing yay..."
    pacman -S --needed --noconfirm base-devel yay
    if ! pacman -Qs yay > /dev/null; then
        echo "Error installing yay. Aborting."
        exit 1
    fi
fi

# Update the system before installing packages
echo -e "\n############################################\n######### Updating system before installing packages #########\n############################################\n"
sudo pacman -Syu --noconfirm

# Start of installing packages
echo -e "\n############################################\n######### Starting installing packages #########\n############################################\n"

# Array of package names to install
packages=(
    "base-devel"
    "cmake"
    "alacritty"
    "fish"
    "plasma-wayland-session"
    "firefox"
    "librewolf-bin"
    "nemo"
    "vlc"
    "evince"
    "bleachbit"
    "sublime-text-4"
    "visual-studio-code-bin"
    "libreoffice-fresh"
    "nodejs"
    "npm"
    "android-tools"
    "tor-browser"
    "ventoy-bin"
    "brave-bin"
    "appimagelauncher"
    "telegram-desktop"
    "simplescreenrecorder"
    "converseen"
    "celluloid"
    "gimp"
)

# Install packages from AUR
for package in "${packages[@]}"; do
    echo -e "\n############################################\n######### Installing ${package} #########\n############################################\n"
    if ! sudo -u "$SUDO_USER" yay -S --needed --noconfirm "$package"; then
        echo "Error installing ${package}. Aborting."
        exit 1
    fi
done

echo -e "\n############################################\n######### All packages installed #########\n############################################\n"

# Invokes the post_setup.sh script for various fixes and tweaks
 echo -e "\n############################################\n######### Initiating Post config script   #########\n############################################\n"
echo "Initiation sucessfull"
sudo chmod +x "post_setup.sh"
sudo ./post_setup.sh

exit 0