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

# Function to print section headers
print_section_header() {
    printf "\n############################################\n"
    printf "######### %s #########\n" "$1"
    printf "############################################\n\n"
}

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Updates mirrors 
print_section_header "Updating mirrors and System"
sudo pacman-mirrors --fasttrack 10 && sudo pacman -Syu --noconfirm || handle_error "Error updating system. Aborting."

# Install yay if not installed
printf "\nChecking if yay is available\n"
if ! command -v yay &>/dev/null; then
    echo "yay is not installed. Installing yay..."
    sudo -u "$SUDO_USER" pacman -S --needed --noconfirm base-devel yay || handle_error "Error installing yay. Aborting."
fi

# Start of installing packages
print_section_header "Starting installing packages"

# Array of package names to install
packages=(
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
    "authenticator"
    "flatpak"
    "docker"
    "lazydocker"
)

# Install packages using yay
print_section_header "Installing packages" 
if ! sudo -u "$SUDO_USER" yay -S --needed --noconfirm --noredownload "${packages[@]}"; then
    handle_error "Error installing packages. Aborting."
fi


print_section_header "All packages installed"

# Invokes the post_setup.sh script for various fixes and tweaks
post_setup_script="post_setup.sh"
if [ -f "$post_setup_script" ]; then
    print_section_header "Initiating Post config script"  
    echo "Initiation successful"
    sudo -u "$SUDO_USER" chmod +x "./$post_setup_script"
    sudo -u "$SUDO_USER" "./$post_setup_script" || handle_error "Error executing post_setup.sh. Aborting."
else
    echo "Warning: post_setup.sh script not found. Skipping post-setup steps."
fi

exit 0
