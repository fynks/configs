#!/usr/bin/env bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
UNATTENDED=false
LOGFILE="/var/log/setup-script.log"
DRY_RUN=false

#--------------------------------
# Section: Basic functions
#--------------------------------

prompt() {
    [[ "$UNATTENDED" == true ]] && return 0
    read -p "${1} (Y/n): " response
    case "${response,,}" in
        n|no) return 1 ;;
        *) return 0 ;;
    esac
}

print_section_header() {
    printf "\n${BLUE}%s\n#### %s ####\n%s${NC}\n\n" "$(printf '#%.0s' {1..50})" "$1" "$(printf '#%.0s' {1..50})"
}

handle_error() {
    local error_msg="$1"
    echo -e "${RED}Error: $error_msg${NC}" >&2
    log "$error_msg" "ERROR"
    cleanup
    exit 1
}

print_success() {
    echo -e "${GREEN}✔ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

log() {
    local message="$1"
    local level="${2:-INFO}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $level: $message" >> "$LOGFILE"
}

cleanup() {
    log "Starting cleanup"
    rm -f /tmp/setup-*
    jobs -p | xargs -r kill
    log "Cleanup completed"
}

show_progress() {
    local pid=$1
    local message=$2
    local spin='-\|/'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${CYAN}[%c] %s...${NC}" "${spin:$i:1}" "$message"
        sleep .1
    done
    printf "\r"
}

validate_environment() {
    local required_commands=(curl wget git sudo)
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            handle_error "Required command '$cmd' not found"
        fi
    done

    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        handle_error "No internet connection detected"
    fi
}

#--------------------------------
# Section: Welcome and Help
#--------------------------------

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  -h, --help        Show this help message and exit
  -u, --unattended  Run the script in unattended mode
  -d, --dry-run     Show what would be done without making changes
EOF
}

welcome() {
    clear
    echo -e "${YELLOW} #-------------------------------------------${NC}"
    echo -e "${YELLOW} #    ______ __     __ _   _  _  __  _____   ${NC}"
    echo -e "${YELLOW} #  |  ____|\ \   / /| \ | || |/ / / ____|   ${NC}"
    echo -e "${YELLOW} #  | |__    \ \_/ / |  \| || ' / | (___     ${NC}"
    echo -e "${YELLOW} #  |  __|    \   /  | . \` ||  <   \___ \\   ${NC}"
    echo -e "${YELLOW} #  | |        | |   | |\  || . \  ____) |   ${NC}"
    echo -e "${YELLOW} #  |_|        |_|   |_| \_||_|\_\|_____/    ${NC}"
    echo -e "${YELLOW} #                                           ${NC}"
    echo -e "${YELLOW} #  Arch Linux Setup Script                  ${NC}"
    echo -e "${YELLOW} #--------------------------------------------${NC}"
    echo ""
    echo -e "${BLUE}Welcome to the Arch Linux Setup script!${NC}"
    echo ""
    echo " This script helps you set up various components of your Arch Linux system:"
    echo " - Set up Chaotic-AUR and update mirrors"
    echo " - Install necessary packages"
    echo " - Set up Firefox policies"
    echo " - Disable extra services"
    echo " - Configure Fish shell"
    echo " - Install optional packages"
    echo ""
}

#--------------------------------
# Section: Mirrors and AUR
#--------------------------------

setup_aur() {
    print_section_header "Setting up Chaotic-AUR and Updating Mirrors"
    if prompt "Do you want to set up Chaotic-AUR and update mirrors?"; then
        sudo -u "$username" firefox "https://github.com/chaotic-aur" &
        sleep 3

        sudo nano "/etc/pacman.conf"
        print_success "Pacman configuration updated"

        sudo pacman-mirrors --fasttrack 5 && sudo pacman -Sy --noconfirm
        print_success "Mirrors updated and system synced"
    else
        print_warning "Chaotic-AUR setup and mirror update skipped"
    fi
}

#----------------------------------------
# Section: Installing Necessary Packages
#----------------------------------------

install_packages() {
    print_section_header "Installing Necessary Packages"
    if prompt "Do you want to install necessary packages?"; then
        # Ensure yay is installed
        if ! command -v yay &> /dev/null; then
            echo "Installing yay..."
            sudo pacman -S --needed --noconfirm yay || handle_error "Failed to install yay"
        fi

        local package_list=(
            base-devel cmake alacritty fish plasma-wayland-session firefox librewolf-bin
            ventoy ente-auth-bin zoxide eza konsave vlc evince sublime-text-4 localsend
            visual-studio-code-bin libreoffice-still android-tools jdownloader2 java-rhino gimp
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
    print_section_header "Setting up Firefox Policies"
    if prompt "Do you want to set up Firefox policies?"; then
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
    print_section_header "Disabling Extra Services"
    if prompt "Do you want to disable extra services?"; then
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
    print_section_header "Setting up Fish Shell"
    if prompt "Do you want to set up Fish shell configuration?"; then
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
    print_section_header "Installing Optional Packages"
    if prompt "Do you want to install optional packages?"; then
        local optional_package_list=(
            brave-bin nodejs npm video-downloader bleachbit appimagelauncher
            telegram-desktop simplescreenrecorder hblock converseen celluloid
            flatpak docker lazydocker
        )

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
    echo -e "${GREEN}Arch Linux setup is complete. Please reboot your system.${NC}"
}

#--------------------------------
# Section: Main Execution
#--------------------------------

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -u|--unattended)
            UNATTENDED=true
            ;;
        -d|--dry-run)
            DRY_RUN=true
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Add trap for cleanup
trap cleanup EXIT

# Check if the script is run as root
[[ $EUID -ne 0 ]] && handle_error "This script must be run as root."

# Get the regular user's username
username="${SUDO_USER:-$USER}"
username=${username:-$(id -un)}

# If username is still empty, prompt the user to enter their username manually
if [[ -z "$username" ]]; then
    read -p "Enter your username: " username
    [[ -z "$username" ]] && handle_error "Username is required."
fi

main() {
    log "Starting setup script"
    validate_environment
    welcome
    
    [[ "$DRY_RUN" == true ]] && echo "Running in dry-run mode. No changes will be made."
    
    setup_aur
    install_packages
    setup_firefox
    disable_services
    setup_fish
    install_optional_packages
    setup_complete
    log "Setup completed successfully"
}

main