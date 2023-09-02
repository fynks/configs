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

# Function to display a highlighted prompt and ask for user confirmation
prompt() {
    local message="$1"
    whiptail --title "Confirmation" --yesno "$message 
    Do you want to continue?" 10 50
    return $?
}


# Function to install packages if missing
install_packages_if_needed() {
    for pkg in "$@"; do
        pacman -Q "$pkg" &>/dev/null || sudo pacman -S --needed --noconfirm "$pkg"
    done
}

# Function to download a file
download_file() {
    local url="$1"
    local destination="$2"
    if ! curl -o "$destination" "$url"; then
        echo "Error: Failed to download $url"
        exit 1
    fi
}

# Section: Setting up Librewolf override.config
print_section_header "Setting up Librewolf override.config"
mkdir -p "$HOME/.librewolf/"
download_file 'https://raw.githubusercontent.com/fynks/configs/main/setup/configs/librewolf.overrides.cfg' "$HOME/.librewolf/librewolf.overrides.cfg"

# Section: Configuring hblock
print_section_header "Configuring hblock"
sudo mkdir -p /etc/hblock/
download_file 'https://raw.githubusercontent.com/fynks/configs/main/setup/configs/hblock_sources.list' '/etc/hblock/sources.list'
sudo hblock

# Section: Fixing VS Code for KDE
print_section_header "Fixing VS Code for KDE"
install_packages_if_needed gnome-keyring libsecret libgnome-keyring
echo -e "Copying the files to the required directory"
download_file 'https://raw.githubusercontent.com/fynks/configs/main/setup/configs/sample_xinitrc_file' "$HOME/.xinitrc"
echo -e "\n DONE  \n"
echo -e "\n Open Seahorse, unlock using your password, then log out and log in again. After that, log in to GitHub in VS Code.\n"

# Download Custom Shortcuts file
print_section_header "Downloading custom_shortcuts file
download_file 'https://raw.githubusercontent.com/fynks/configs/main/configs/setup/configs/custom_shortcuts.kksrc' "$HOME/Downloads/custom_shortcuts.kksrc"

# Prompt for disabling services
prompt "Now script will Disable and mask extra services" || exit 0

declare -A services=(
    ["bluetooth"]="Bluetooth"
    ["lvm2-monitor"]="LVM2 Monitor"
    ["docker"]="Docker"
    ["ModemManager"]="ModemManager"
)

# Function to check if a service is active
is_service_active() {
    sudo systemctl is-active --quiet "${1}.service"
    return $?
}

# Function to check if a service is disabled and masked
is_service_disabled_and_masked() {
    sudo systemctl is-enabled --quiet "${1}.service" && sudo systemctl is-masked --quiet "${1}.service"
    return $?
}

# Function to disable and mask a service
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

    sudo systemctl disable "${service}.service"
    sudo systemctl mask "${service}.service"

    if [ $? -eq 0 ]; then
        echo "Successfully disabled and masked $description service."
    else
        echo "Error occurred while disabling and masking $description service."
    fi
}

# Loop through the services and perform actions
for service in "${!services[@]}"; do
    description="${services[$service]}"
    print_section_header "Disabling and masking $description service ($service)"
    disable_and_mask_service "$service" "$description"
done

# Section: Setup Complete, please reboot
print_section_header "Setup Complete, please reboot"

# Optional: Enabling docker-service
prompt "Do you want to enable Docker services" || exit 0
print_section_header "Enabling docker-service"
sudo systemctl start docker.service
sudo systemctl enable docker.service

print_section_header "Everything is Done,Please Reboot"
sleep 1

exit 0