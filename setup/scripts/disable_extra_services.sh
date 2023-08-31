#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   ______ __     __ _   _  _  __  _____ 
# |  ____|\ \   / /| \ | || |/ / / ____|
# | |__    \ \_/ / |  \| || ' / | (___  
# |  __|    \   /  | . ` ||  <   \___ \ 
# | |        | |   | |\  || . \  ____) |
# |_|        |_|   |_| \_||_|\_\|_____/ 
#                                       
#  Arch Linux script for disabling extra services
#-------------------------------------------------------------------------
# Define an associative array for services and their descriptions
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
    printf "\n##################################################################################################\n"
    echo "#### Disabling and masking $description service ($service) ####"
    printf "##################################################################################################\n"

    disable_and_mask_service "$service" "$description"
done