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

# Function to check if a service is active
is_service_active() {
    local service="$1"
    sudo systemctl is-active --quiet "${service}.service"
    return $?
}

# Function to check if a service is disabled and masked
is_service_disabled_and_masked() {
    local service="$1"
    sudo systemctl is-enabled --quiet "${service}.service" && \
    sudo systemctl status "${service}.service" | grep -q 'masked'
    return $?
}

# Function to disable and mask a service if not already disabled and masked
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

    # Add installation configuration
    sudo systemctl preset "${service}.service"

    if [ $? -eq 0 ]; then
        echo "Successfully disabled and masked $description service."
    else
        echo "Error occurred while disabling and masking $description service."
    fi
}

# Prompt for disabling services
prompt "Now script will Disable and mask extra services" || exit 0

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
    print_section_header "Disabling and masking $description service"
    disable_and_mask_service "$service" "$description"
done

# Section: Setup Complete, please reboot
print_section_header "Setup Complete, please reboot"

# Optional: Enabling docker-service
prompt "Do you want to enable Docker services" || exit 0
print_section_header "Enabling docker-service"
sudo systemctl enable --now docker.service

print_section_header "Everything is Done, Please Reboot"

exit 0