#!/usr/bin/env bash

set -euo pipefail

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

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#--------------------------------
# Section: Basic functions
#--------------------------------

prompt() {
    whiptail --title "Confirmation" --yesno "${1}\nDo you want to continue?" 10 60 3>&1 1>&2 2>&3
}

print_section_header() {
    printf "\n${BLUE}%s\n#### %s ####\n%s${NC}\n\n" "$(printf '#%.0s' {1..50})" "${1}" "$(printf '#%.0s' {1..50})"
}

handle_error() {
    whiptail --title "Error" --msgbox "Error: ${1}" 10 60
    exit 1
}

print_success() {
    printf "${GREEN}✔ %s${NC}\n" "$1"
}

print_warning() {
    printf "${YELLOW}⚠ %s${NC}\n" "$1"
}

# Check if the script is run as root
[[ $EUID -ne 0 ]] && handle_error "This script must be run as root."

# Get the regular user's username
username="${SUDO_USER:-$USER}"
username=${username:-$(id -un)}

# If username is still empty, prompt the user to enter their username manually
if [[ -z "$username" ]]; then
    username=$(whiptail --inputbox "Enter your username:" 10 60 3>&1 1>&2 2>&3)
    [[ $? -ne 0 ]] && handle_error "Username is required."
fi

#--------------------------------
# Section: Welcome
#--------------------------------

welcome() {
    local message="
    * Welcome $username to Arch Linux Setup script *

This script will:
    • Setup Chaotic-AUR and enable pacman parallel downloading
    • Update mirrors and install packages
    • Prompt if you want to disable extra services
    • Set up Firefox policies
    • Configure Fish shell"
    whiptail --title "Welcome" --msgbox "$message" 20 60
}

#--------------------------------
# Section: Mirrors and AUR
#--------------------------------

setup_aur() {
    if prompt "Do you want to set up Chaotic-AUR and update mirrors?"; then
        print_section_header "Set up Chaotic-AUR"
        sudo -u "$username" xdg-open "https://github.com/chaotic-aur" &

        if prompt "Opening pacman config in nano to enable parallel downloading."; then 
            sudo nano "/etc/pacman.conf"
            print_success "Pacman configuration updated"
        else
            print_warning "Pacman configuration update skipped"
        fi

        if prompt "Update mirrors and sync package databases?"; then
            print_section_header "Updating mirrors and System"
            sudo pacman-mirrors --fasttrack 5 && sudo pacman -Sy --noconfirm
            print_success "Mirrors updated and system synced"
        else
            print_warning "Mirror update and system sync skipped"
        fi
    else
        print_warning "Chaotic-AUR setup and mirror update skipped"
    fi
}

#----------------------------------------
# Section: Installing Necessary Packages
#----------------------------------------

install_packages() {
    if prompt "Do you want to install necessary packages?"; then
        print_section_header "Installing necessary packages"

        # Ensure yay is installed
        if ! command -v yay &> /dev/null; then
            echo "Installing yay..."
            sudo pacman -S --needed --noconfirm yay || handle_error "Failed to install yay"
        fi

        local package_list=(
            base-devel cmake alacritty fish plasma-wayland-session firefox librewolf
            ventoy zoxide eza konsave nemo vlc evince otpclient sublime-text-4
            visual-studio-code-bin libreoffice-still android-tools gimp
        )

        echo "Installing necessary packages..."
        if sudo -u "$username" yay -S --needed --noconfirm --noredownload "${package_list[@]}"; then
            print_success "Necessary packages installation successful"
        else
            handle_error "Error installing necessary packages"
        fi
    else
        print_warning "Necessary package installation skipped"
    fi
}

#--------------------------------
# Section: Firefox
#--------------------------------

setup_firefox() {
    if prompt "Do you want to set up Firefox policies?"; then
        print_section_header "Setting up Firefox policies"
        if sudo mkdir -p /etc/firefox/policies/ &&
           sudo cp /home/"$username"/configs/browsers/policies.json /etc/firefox/policies/policies.json; then
            print_success "Firefox policies copied successfully"
        else
            handle_error "Error copying Firefox policies"
        fi
    else
        print_warning "Firefox policy setup skipped"
    fi
}

#--------------------------------
# Section: Disabling services
#--------------------------------

disable_services() {
    if prompt "Do you want to disable extra services?"; then
        print_section_header "Disabling extra services"

        local services=(
            bluetooth
            lvm2-monitor
            docker
            ModemManager
        )

        for service in "${services[@]}"; do
            if systemctl is-enabled --quiet "$service"; then
                echo "Disabling $service service..."
                if systemctl stop "$service" &&
                   systemctl disable "$service" &&
                   systemctl mask "$service"; then
                    print_success "$service service disabled and masked."
                else
                    print_warning "Failed to disable $service service."
                fi
            else
                print_warning "$service service is already disabled."
            fi
        done
    else
        print_warning "Service disabling skipped"
    fi
}

#--------------------------------
# Section: Fish
#--------------------------------

setup_fish() {
    if prompt "Do you want to set up Fish shell configuration?"; then
        print_section_header "Setting up Fish shell"
        if sudo -u "$username" cp /home/"$username"/configs/setup/config.fish /home/"$username"/.config/fish/config.fish; then
            print_success "Fish config copied successfully"
        else
            handle_error "Error copying Fish config"
        fi
    else
        print_warning "Fish shell setup skipped"
    fi
}

#-------------------------------------
# Section: Installing Optional Packages
#-------------------------------------

install_optional_packages() {
    if prompt "Do you want to install optional packages?"; then
        local optional_package_list=(
            brave-bin nodejs npm video-downloader bleachbit appimagelauncher
            telegram-desktop simplescreenrecorder hblock converseen celluloid
            flatpak docker lazydocker
        )

        print_section_header "Installing optional packages"
        echo "Installing optional packages..."
        if sudo -u "$username" yay -S --needed --noconfirm --noredownload "${optional_package_list[@]}"; then
            print_success "Optional package installation complete"
        else
            handle_error "Error installing optional packages"
        fi
    else
        print_warning "Optional package installation skipped"
    fi
}

#--------------------------------
# Section: Exit
#--------------------------------

setup_complete() {
    print_section_header "Setup Complete"
    whiptail --title "Setup Complete" --msgbox "Arch Linux setup is complete. Please reboot your system." 10 60
}

show_help() {
    whiptail --title "Help" --msgbox "Usage: $0 [OPTIONS]

Options:
--setup-aur              Setup Chaotic-AUR and enable pacman parallel downloading
--install-packages       Install necessary packages
--setup-firefox          Setup Firefox policies
--disable-services       Disable and mask extra services
--setup-fish             Setup Fish shell configuration
--install-optional-packages Install optional packages
--help                   Display this help message" 20 70
}

main() {
    if [[ $# -eq 0 ]]; then
        welcome
        setup_aur
        install_packages
        setup_firefox
        disable_services
        setup_fish
        install_optional_packages
        setup_complete
    else
        case "$1" in
            --setup-aur) setup_aur ;;
            --install-packages) install_packages ;;
            --setup-firefox) setup_firefox ;;
            --disable-services) disable_services ;;
            --setup-fish) setup_fish ;;
            --install-optional-packages) install_optional_packages ;;
            --help) show_help ;;
            *) 
                echo "Usage: $0 {--setup-aur|--install-packages|--setup-firefox|--setup-fish|--disable-services|--install-optional-packages|--help}"
                exit 1
                ;;
        esac
    fi
}

main "$@"