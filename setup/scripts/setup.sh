#!/usr/bin/env bash
#-------------------------------------------------------------------------
#    ______ __     __ _   _  _  __  _____
#  |  ____|\ \   / /| \ | || |/ / / ____|
#  | |__    \ \_/ / |  \| || ' / | (___
#  |  __|    \   /  | . ` ||  <   \___ \
#  | |        | |   | |\  || . \  ____) |
#  |_|        |_|   |_| \_||_|\_\|_____/
#
#  Arch Linux Setup script
#-------------------------------------------------------------------------

# Function to display a highlighted prompt and ask for user confirmation
prompt() {
    local message="$1"
    whiptail --title "Confirmation" --yesno "$message 
    Do you want to continue?" 10 50
    return $?
}

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

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    handle_error "This script must be run as root."
fi

# Get the regular user's username
username=$(logname)

# Function to display a welcome message and ask for user confirmation
welcome() {
    local message="
    * Welcome $username to Arch Linux Setup script.*
This script will:
    * Setup Chaotic-AUR and enable pacman parallel downloading
    * Update mirrors and install packages
    * Prompt if you want to disable extra services"
    whiptail --title "Welcome" --msgbox "$message" 20 50 --ok-button "continue"
    return $?
}

# Welcome the user and ask for confirmation
welcome || exit 0

# Open Chaotic-AUR GitHub page in the default browser
prompt "Opening Chaotic-AUR GitHub page. Make sure to enable it." || exit 0
sudo -u "$username" firefox "https://github.com/chaotic-aur" &
sleep 3

# Prompt the user before editing pacman config
prompt "Opening pacman config in nano to enable parallel downloading." || exit 0
sudo nano "/etc/pacman.conf"

# Notifying this will now continue continue on its own
prompt "Now script will update mirrors and start installing package" || exit 0

# Updates mirrors
print_section_header "Updating mirrors and System"
sudo pacman-mirrors --fasttrack 10 && sudo pacman -Sy --noconfirm

# Installing yay
sudo pacman -S --needed --noconfirm yay

# Array of package names to install
package_list=(
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
    "libreoffice-still"
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
    "flatpak"
    "docker"
    "lazydocker"
)

# Install packages using yay
print_section_header "Installing packages"
if ! sudo -u "$SUDO_USER" yay -S --needed --noconfirm --noredownload "${package_list[@]}"; then
    handle_error "Error installing packages. Aborting."
fi

# Install successful
print_section_header "All packages installed"

# Invokes the post_setup.sh script for various fixes and tweaks
print_section_header "Initiating Post config script"
echo "Initiation successful"
if ! sudo chmod +x "./post_setup.sh" && sudo "./post_setup.sh"; then
    handle_error "Error executing post_setup.sh. Aborting."
fi
exit 0
