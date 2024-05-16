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

#--------------------------------
# Section: Basic functions
#--------------------------------

# Display a highlighted prompt and ask for user confirmation
prompt() {
    local message="$1"
    whiptail --title "Confirmation" --yesno "$message 
    Do you want to continue?" 10 50
    return $?
}

# Print section headers
print_section_header() {
    printf "\n############################################\n"
    printf "######### %s #########\n" "$1"
    printf "############################################\n\n"
}

# Handling errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    handle_error "This script must be run as root."
fi

# Get the regular user's username
username="$USER"

# If $USER is empty or not available, fallback to id command
if [ -z "$username" ]; then
    username=$(id -un)
fi

# If username is still empty, prompt the user to enter their username manually
if [ -z "$username" ]; then
    read -p "Enter your username: " username
fi

#--------------------------------
# Section: Welcome
#--------------------------------

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

#--------------------------------
# Section: Mirrors and AUR
#--------------------------------

# Open Chaotic-AUR GitHub page in the default browser
print_section_header "Set up Chaotic-AUR"
printf "https://github.com/chaotic-aur\n"

# Prompt the user before editing pacman config
prompt "Opening pacman config in nano to enable parallel downloading." || exit 0
sudo nano "/etc/pacman.conf"

# Notifying this will now continue continue on its own
prompt "Now script will update mirrors and start installing package" || exit 0

# Updates mirrors
print_section_header "Updating mirrors and System"
sudo pacman-mirrors --fasttrack 10 && sudo pacman -Sy --noconfirm

#----------------------------------------
# Section: Installing Necessary Packages
#----------------------------------------

# Installing yay
sudo pacman -S --needed --noconfirm yay

# Function to install packages using yay
install_packages() {
    local packages=("$@")
    if ! sudo -u "$SUDO_USER" yay -S --needed --noconfirm --noredownload "${packages[@]}"; then
        handle_error "Error installing packages. Aborting."
    fi
}
# Array of package names to install
package_list=(
    "cmake"
    "alacritty"
    "fish"
    "plasma-wayland-session"
    "firefox"
    "librewolf-bin"
    "ventoy-bin"
    "konsave"
    "nemo"
    "vlc"
    "evince"
    "otpclient"
    "sublime-text-4"
    "visual-studio-code-bin"
    "libreoffice-still"
    "android-tools"
    "gimp"
)

# Install packages using the function
print_section_header "Installing packages"
install_packages "${package_list[@]}"

# Install successful
print_section_header "Necessary packages installation successful"

#--------------------------------
# Section: Firefox
#--------------------------------


# copy firefox policies
print_section_header "Copying Firefox policies"
if ! sudo mkdir /etc/firefox/policies/ && sudo cp ~/configs/browsers/policies.json /etc/firefox/policies/policies.json; then
    handle_error "Error copying firefox policies"
fi

#--------------------------------
# Section: Diabling services
#--------------------------------

# Disbaling and masking extra services
print_section_header "Disabling extra services"

# Check if a service is active
is_service_active() {
    local service="$1"
    sudo systemctl is-active --quiet "${service}.service"
}

# Check if a service is disabled and masked
is_service_disabled_and_masked() {
    local service="$1"
    sudo systemctl is-enabled --quiet "${service}.service" && \
    sudo systemctl status "${service}.service" | grep -q 'masked'
}

# Disable and mask a service if not already disabled and masked
disable_and_mask_service() {
    local service="$1"
    local description="$2"

    if is_service_disabled_and_masked "$service"; then
        echo "$description service is already disabled and masked. Skipping..."
        return
    fi

    if is_service_active "$service"; then
        sudo systemctl stop "${service}.service"
        if [ $? -eq 0 ]; then
            echo "Stopped $description service."
        else
            echo "Error stopping $description service."
        fi
    else
        echo "$description service is already inactive."
    fi

    sudo systemctl disable --now "${service}.service"
    sudo systemctl mask "${service}.service"
    sudo systemctl preset "${service}.service" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "Successfully disabled and masked $description service."
    else
        echo "Error occurred while disabling and masking $description service."
    fi
}

# Array of services to disable and mask
services=(
    "bluetooth"
    "lvm2-monitor"
    "docker"
    "ModemManager"
)

# Loop through the services and perform actions
for service in "${services[@]}"; do
    description="$service"
    echo "Disabling and masking $description service"
    disable_and_mask_service "$service" "$description"
done

#-------------------------------------
# Section: Installing Extra Packages
#-------------------------------------

# Ask user for optional package installation
prompt "
Do you want to install optional packages?
 *If you cancelled then script will simply exit.*
" || exit 0

# Array of optional package names
optional_package_list=(
    "brave-bin"
    "nodejs"
    "npm"
    "video-downloader"
    "bleachbit"
    "appimagelauncher"
    "telegram-desktop"
    "simplescreenrecorder"
    "hblock"
    "converseen"
    "celluloid"
    "flatpak"
    "docker"
    "lazydocker"
)

# Install optional packages using the function
print_section_header "Installing optional packages"
install_packages "${optional_package_list[@]}"

# Install successful
print_section_header "Optional package installation complete"


#--------------------------------
# Section: Exit
#--------------------------------

# Section: Setup Complete, please reboot
print_section_header "Setup Complete, please reboot"

exit 0
