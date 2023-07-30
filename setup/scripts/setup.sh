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
    echo "Error: This script must be run as root."
    exit 1
fi

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Updates the mirrors
printf "\n############################################\n######### Pacman Branch, mirrors, and databases updates #########\n############################################\n"
echo "Updating mirrors with fastest mirrors"
if ! sudo pacman-mirrors --fasttrack 10; then
    handle_error "Error updating mirrors. Aborting."
fi

# Syncs the databases
printf "\nSyncing databases\n"
sudo pacman -Syu || handle_error "Error syncing databases. Aborting."

# Install yay if not installed
printf "\nChecking if yay is available\n"
if ! command -v yay &>/dev/null; then
    echo "yay is not installed. Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel yay || handle_error "Error installing yay. Aborting."
fi

# Update the system before installing packages
printf "\n############################################\n######### Updating system before installing packages #########\n############################################\n"
sudo pacman -Syu --noconfirm || handle_error "Error updating system. Aborting."

# Start of installing packages
printf "\n############################################\n######### Starting installing packages #########\n############################################\n"

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
    "video-downloader"
    "bleachbit"
    "otpclient"
    "sublime-text-4"
    "visual-studio-code-bin"
    "libreoffice-fresh"
    "nodejs"
    "npm"
    "android-tools"
    "tor-browser"
    "ventoy-bin"
    "brave-bin"
    "hblock"
    "appimagelauncher"
    "telegram-desktop"
    "simplescreenrecorder"
    "converseen"
    "celluloid"
    "gimp"
)


# Install packages from AUR
for package in "${packages[@]}"; do
    printf "\n############################################\n######### Installing "$package" #########\n############################################\n" 
    if ! sudo -u "$SUDO_USER" yay -S --needed --noconfirm --noredownload "$package"; then
        handle_error "Error installing $package. Aborting."
    fi
done

printf "\n############################################\n######### All packages installed #########\n############################################\n"

# Invokes the post_setup.sh script for various fixes and tweaks
post_setup_script="post_setup.sh"
if [ -f "$post_setup_script" ]; then
    printf "\n############################################\n######### Initiating Post config script   #########\n############################################\n"
    echo "Initiation successful"
    sudo chmod +x "$post_setup_script"
    sudo -u "$SUDO_USER" "./$post_setup_script" || handle_error "Error executing post_setup.sh. Aborting."
else
    echo "Warning: post_setup.sh script not found. Skipping post-setup steps."
fi

exit 0