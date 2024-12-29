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

#--------------------------------
# Section: Basic functions
#--------------------------------

prompt() {
    if [[ "$UNATTENDED" == true ]]; then
        return 0  # Assume 'yes' in unattended mode
    fi
    local response
    while true; do
        read -p "$1 [Y/n]: " response
        case "$response" in
            [Yy]*|'') return 0 ;;
            [Nn]*)     return 1 ;;
            *)         echo "Please answer yes or no." ;;
        esac
    done
}
print_section_header() {
    local line_length=50
    local line
    line=$(printf '#%.0s' $(seq 1 $line_length))
    printf "\n${BLUE}%s\n#### %s ####\n%s${NC}\n\n" "$line" "$1" "$line"
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
    jobs -p | xargs -r kill &>/dev/null
    log "Cleanup completed"
}

show_progress() {
    local pid=$1
    local message=$2
    local spin='-\|/'
    local i=0
    tput civis
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${CYAN}[%c] %s...${NC}" "${spin:$i:1}" "$message"
        sleep .1
    done
    tput cnorm
    printf "\r"
}

validate_environment() {
    local required_commands=(curl wget git sudo jq)
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            handle_error "Required command '$cmd' not found. Please install it and re-run the script."
        fi
    done

    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        handle_error "No internet connection detected. Please check your network and try again."
    fi
}

automatic_setup() {
    for step in setup_aur install_packages setup_firefox disable_services setup_fish install_optional_packages; do
        print_section_header "Running $step"
        if prompt "Do you want to proceed with $step?"; then
            $step
        else
            print_warning "Skipped $step"
        fi
    done
    setup_complete
    exit 0
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

This script helps you set up various components of your Arch Linux system.
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
}

#--------------------------------
# Section: Main Menu
#--------------------------------
main_menu() {
    local options=(
        "Run automatic setup"  # Option 1
        "Set up Chaotic-AUR and update mirrors"
        "Install necessary packages"
        "Set up Firefox policies"
        "Disable unnecessary services"
        "Configure Fish shell"
        "Install optional packages"
        "Exit"
    )
    echo "Please select an option:"
    for i in "${!options[@]}"; do
        printf "%d) %s\n" $((i+1)) "${options[$i]}"
    done
    read -p "Enter your choice [1-${#options[@]}]: " REPLY
    REPLY=${REPLY:-1}  # Default to 1 if no input
    case $REPLY in
        1) automatic_setup ;;
        2) setup_aur ;;
        3) install_packages ;;
        4) setup_firefox ;;
        5) disable_services ;;
        6) setup_fish ;;
        7) install_optional_packages ;;
        8) setup_complete; exit 0 ;;
        *) echo -e "${YELLOW}Invalid option. Try again.${NC}" ;;
    esac
}
#--------------------------------
# Section: Setup Functions
#--------------------------------

setup_aur() {
    print_section_header "Setting up Chaotic-AUR and Updating Mirrors"
    if prompt "Do you want to set up Chaotic-AUR and update mirrors?"; then

        # Update package databases
        pacman -Sy && pacman -S jq --noconfirm
        
        # Import Chaotic-AUR key
        pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
        pacman-key --lsign-key 3056513887B78AEB

        # Add Chaotic-AUR repository if not already added
        if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
            cat <<EOF >> /etc/pacman.conf

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
        fi

        # Install keyring and mirrorlist
        pacman -Sy --noconfirm chaotic-keyring chaotic-mirrorlist

        # Update package databases
        pacman -Syyu --noconfirm
        print_success "Chaotic-AUR repository added and system updated"
    else
        print_warning "Chaotic-AUR setup and mirror update skipped"
    fi
}

install_packages() {
    print_section_header "Installing Necessary Packages"
    if prompt "Do you want to install necessary packages?"; then
        if ! command -v yay &> /dev/null; then
            echo "Installing yay..."
            if sudo pacman -S --needed --noconfirm yay; then
                print_success "yay installed successfully"
            else
                handle_error "Failed to install yay"
            fi
        fi

        local package_list=(
            base-devel cmake alacritty fish plasma-wayland-session firefox librewolf-bin
            ventoy zoxide eza konsave vlc evince sublime-text-4 jq parallel localsend
            visual-studio-code-bin libreoffice-still android-tools jdownloader2 java-rhino gimp
        )

        echo "Installing necessary packages..."
        if sudo -u "$username" yay -S --needed --noconfirm --noredownload "${package_list[@]}"; then
            print_success "Necessary packages installation successful"
            download_ente_auth
        else
            handle_error "Error installing necessary packages"
        fi
    else
        print_warning "Necessary package installation skipped"
    fi
}

download_ente_auth() {
    print_section_header "Downloading Ente Auth"
    if prompt "Do you want to download the latest Ente Auth AppImage?"; then
        # GitHub API URL for the latest release
        local API_URL="https://api.github.com/repos/ente-io/ente/releases/latest"

        echo "Fetching latest release information..."
        local RELEASE_DATA
        RELEASE_DATA=$(curl -s "$API_URL")

        if [ $? -ne 0 ]; then
            handle_error "Failed to fetch Ente release information"
        fi

        # Extract the download URL for the x86_64 AppImage
        local DOWNLOAD_URL
        DOWNLOAD_URL=$(echo "$RELEASE_DATA" | \
            jq -r '.assets[] | select(.name | contains("x86_64.AppImage")) | .browser_download_url')

        if [ -z "$DOWNLOAD_URL" ]; then
            handle_error "Could not find Ente AppImage download URL"
        fi

        # Extract version from the URL for the filename
        local VERSION
        VERSION=$(echo "$DOWNLOAD_URL" | grep -oP 'auth-v\d+\.\d+\.\d+')
        local FILENAME="ente-$VERSION-x86_64.AppImage"
        local DOWNLOAD_PATH="/home/$username/Applications"

        # Create Applications directory if it doesn't exist
        mkdir -p "$DOWNLOAD_PATH"

        # Download the AppImage
        echo "Downloading $FILENAME..."
        if curl -L -o "$DOWNLOAD_PATH/$FILENAME" "$DOWNLOAD_URL"; then
            chmod +x "$DOWNLOAD_PATH/$FILENAME"
            print_success "Successfully downloaded $FILENAME to $DOWNLOAD_PATH"
        else
            handle_error "Ente Auth download failed"
        fi
    else
        print_warning "Ente Auth download skipped"
    fi
}

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

disable_services() {
    print_section_header "Disabling Unnecessary Services"
    if prompt "Do you want to disable unnecessary services?"; then
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
                   systemctl disable "$service"; then
                    print_success "$service service disabled."
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
           *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Add trap for cleanup
trap cleanup EXIT SIGINT SIGTERM

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    handle_error "This script must be run as root. Please run with sudo or as root user."
fi

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

    main_menu

    setup_complete
    log "Setup completed successfully"
}

main