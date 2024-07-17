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
    whiptail --title "Confirmation" --yesno "$message\nDo you want to continue?" 10 50
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
    whiptail --title "Error" --msgbox "Error: $1" 10 50
    exit 1
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    handle_error "This script must be run as root."
fi

# Get the regular user's username
username="${SUDO_USER:-$USER}"

# If $SUDO_USER or $USER is empty or not available, fallback to id command
if [ -z "$username" ]; then
    username=$(id -un)
fi

# If username is still empty, prompt the user to enter their username manually
if [ -z "$username" ]; then
    username=$(whiptail --inputbox "Enter your username:" 10 50 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        handle_error "Username is required."
    fi
fi

#--------------------------------
# Section: Welcome
#--------------------------------

# Function to display a welcome message
welcome() {
    local message="
    * Welcome $username to Arch Linux Setup script. *
This script will:
    * Setup Chaotic-AUR and enable pacman parallel downloading
    * Update mirrors and install packages
    * Prompt if you want to disable extra services"
    whiptail --title "Welcome" --msgbox "$message" 20 50
}

#--------------------------------
# Section: Mirrors and AUR
#--------------------------------

setup_aur() {
    # Open Chaotic-AUR GitHub page in the default browser
    print_section_header "Set up Chaotic-AUR"
    printf "https://github.com/chaotic-aur" &

    # Prompt the user before editing pacman config
    if prompt "Opening pacman config in nano to enable parallel downloading."; then
        sudo nano "/etc/pacman.conf"
    else
        exit 0
    fi

    # Notifying this will now continue on its own
    if prompt "Now script will update mirrors and start installing packages"; then
        print_section_header "Updating mirrors and System"
        sudo pacman-mirrors --fasttrack 5 && sudo pacman -Sy --noconfirm
    else
        exit 0
    fi
}

#----------------------------------------
# Section: Installing Necessary Packages
#----------------------------------------

install_packages() {
    # Installing yay
    sudo pacman -S --needed --noconfirm yay

    # Function to install packages using yay
    install_packages_list() {
        local packages=("$@")
        if ! sudo -u "$SUDO_USER" yay -S --needed --noconfirm --noredownload "${packages[@]}"; then
            handle_error "Error installing packages. Aborting."
        fi
    }

    # Array of package names to install
    local package_list=(
        "base-devel"
        "cmake"
        "alacritty"
        "fish"
        "plasma-wayland-session"
        "firefox"
        "librewolf"
        "ventoy"
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
    install_packages_list "${package_list[@]}"

    # Install successful
    print_section_header "Necessary packages installation successful"
}

#--------------------------------
# Section: Firefox
#--------------------------------

setup_firefox() {
    # Copy Firefox policies
    print_section_header "Copying Firefox policies"
    if ! sudo mkdir -p /etc/firefox/policies/ && sudo cp ~/configs/browsers/policies.json /etc/firefox/policies/policies.json; then
        handle_error "Error copying Firefox policies"
    fi
}

#--------------------------------
# Section: Disabling services
#--------------------------------

disable_services() {
    # Disabling and masking extra services
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
    local services=(
        "bluetooth"
        "lvm2-monitor"
        "docker"
        "ModemManager"
    )

    # Loop through the services and perform actions
    for service in "${services[@]}"; do
        echo "Disabling and masking $service service"
        disable_and_mask_service "$service" "$service"
    done
}

#--------------------------------
# Section: Fish
#--------------------------------

setup_fish() {
    # Copy Fish config
    print_section_header "Copying Fish config"
    if ! cp ~/configs/setup/config.fish ~/.config/fish/config.fish; then
        handle_error "Error copying Fish config"
    fi
}

#-------------------------------------
# Section: Installing Extra Packages
#-------------------------------------

install_optional_packages() {
    # Ask user for optional package installation
    if prompt "Do you want to install optional packages?\n*If you cancel, the script will simply exit.*"; then
        # Array of optional package names
        local optional_package_list=(
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
        install_packages_list "${optional_package_list[@]}"

        # Install successful
        print_section_header "Optional package installation complete"
    else
        exit 0
    fi
}

#--------------------------------
# Section: Exit
#--------------------------------

# Section: Setup Complete, please reboot
setup_complete() {
    print_section_header "Setup Complete, please reboot"
}


# Function to display help message
show_help() {
    whiptail --title "Help" --msgbox "Usage: $0 [OPTIONS]

Options:
--setup-aur              Setup Chaotic-AUR and enable pacman parallel downloading
--install-packages       Install necessary packages
--setup-firefox          Setup Firefox policies
--disable-services       Disable and mask extra services
--install-optional-packages Install optional packages
--help                   Display this help message" 20 70
}

# Run all sections if no arguments are provided
if [ $# -eq 0 ]; then
    welcome
    setup_aur
    install_packages
    setup_firefox
    disable_services
    install_optional_packages
    setup_complete
else

# Parse command-line arguments
case "$1" in
    --setup-aur)
        setup_aur
        ;;
    --install-packages)
        install_packages
        ;;
    --setup-firefox)
        setup_firefox
        ;;
    --disable-services)
        disable_services
        ;;
    --setup-fish)
        setup_fish
        ;;
    --install-optional-packages)
        install_optional_packages
        ;;
    --help)
        show_help
        ;;
    *)
        echo "Usage: $0 {--setup-aur|--install-packages|--setup-firefox|--setup-fish|--disable-services|--install-optional-packages|--help}"
        exit 1
        ;;
esac
fi

exit 0
