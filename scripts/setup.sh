#!/usr/bin/env bash

set -euo pipefail


#======================================
# Section: Configuration
#======================================

# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Log File
LOGFILE="/var/log/setup-script.log"

# Runtime flags (can be overridden by CLI)
ASSUME_YES=false
ASSUME_NO=false
COLOR_ENABLED=true

# Resolve repository root (allows overriding with CONFIGS_DIR)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="${CONFIGS_DIR:-$(cd "$SCRIPT_DIR/.." && pwd)}"



#================================
# Section: Core Functions
#================================

#--------------------------------
# Section: UI Elements
#--------------------------------
prompt() {
    local response
    # Honor non-interactive defaults
    if [[ "$ASSUME_YES" == true ]]; then
        printf "%b%s%b [Y/n]: Y (auto)\n" "$YELLOW" "$1" "$NC"
        return 0
    fi
    if [[ "$ASSUME_NO" == true ]]; then
        printf "%b%s%b [y/N]: N (auto)\n" "$YELLOW" "$1" "$NC"
        return 1
    fi
    while true; do
        read -r -p "$(echo -e "${YELLOW}$1 [Y/n]: ${NC}")" response
        case "${response:-Y}" in
            [Yy]* ) return 0 ;;
            [Nn]* ) return 1 ;;
            * )     echo "Please answer yes or no." ;;
        esac
    done
}

print_section_header() {
    local title="$1"
    local width=60
    local padding=$(( (width - ${#title}) / 2 ))
    
    # Top border
    printf "\n${YELLOW}━━━━━━━━━━━━━━━━ %s ━━━━━━━━━━━━━━━━${NC}\n" "$title"
    
    # Subtle separator
    printf "${CYAN}│${NC}\n"
}
handle_error() {
    local error_msg="$1"
    local timestamp=$(date '+%H:%M:%S')
    printf "\n${RED}━━━━━━━━━━━━━━━━ ERROR ━━━━━━━━━━━━━━━━${NC}\n"
    printf "${RED}│${NC} ⛔ %s\n" "$error_msg"
    printf "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n\n"
    log "$error_msg" "ERROR"
    cleanup
    exit 1
}

# Error trap helper to surface failing command
on_error() {
    local exit_code=$?
    local cmd=${BASH_COMMAND:-unknown}
    handle_error "Command failed (exit $exit_code): $cmd"
}

print_success() {
    local msg="$1"
    printf "\n${GREEN}✓${NC} ${GREEN}%s${NC}\n" "$msg"
}

print_warning() {
    local msg="$1"
    printf "\n${YELLOW}⚠${NC} ${YELLOW}%s${NC}\n" "$msg"
}

log() {
    local message="$1"
    local level="${2:-INFO}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $level: $message" >> "$LOGFILE"
}

# Initialize logging target safely
init_logging() {
    mkdir -p "/var/log" || true
    touch "$LOGFILE" || true
    chmod 0644 "$LOGFILE" || true
}

#--------------------------------
# Section: Cleanup
#--------------------------------
cleanup() {
    log "Starting cleanup"
    rm -f /tmp/setup-*
    jobs -p | xargs -r kill &>/dev/null
    log "Cleanup completed"
}


#--------------------------------
# Section: Validation
#--------------------------------
validate_environment() {

    # System checks
    printf "\n${CYAN}Performing system checks...${NC}\n"

    # Ensure we're on an Arch-based system with pacman
    if ! command -v pacman &>/dev/null; then
        handle_error "This script requires pacman (Arch/Manjaro/etc.). Aborting."
    fi
    
    # Map dependencies to package names
    declare -A pkg_map=(
        ["curl"]="curl"
        ["wget"]="wget"
        ["git"]="git"
        ["sudo"]="sudo"
        ["jq"]="jq"
    )
    
    local missing_pkgs=()
    
    # Check for missing dependencies
    for cmd in "${!pkg_map[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_pkgs+=("${pkg_map[$cmd]}")
        fi
    done
    
    # If there are missing packages, try to install them
    if [ ${#missing_pkgs[@]} -ne 0 ]; then
        echo -e "${YELLOW}Missing required dependencies. Attempting to install packages...${NC}"
        
        # Update package database first
        if ! pacman -Sy --noconfirm; then
            handle_error "Failed to update package database"
        fi
        
        # Install missing packages
        if ! pacman -S --noconfirm "${missing_pkgs[@]}"; then
            handle_error "Failed to install required packages: ${missing_pkgs[*]}"
        fi
        
        print_success "Successfully installed required packages"
    fi
    
    # Internet connectivity check (ICMP, then HTTP fallback)
    local dns_servers=("8.8.8.8" "1.1.1.1" "9.9.9.9")
    local connected=false
    
    for server in "${dns_servers[@]}"; do
        if ping -c 1 -W 2 "$server" &> /dev/null; then
            connected=true
            break
        fi
    done
    
    if [ "$connected" = false ]; then
        if command -v curl &>/dev/null && curl -sI --max-time 3 https://archlinux.org | grep -qi "200"; then
            connected=true
        fi
    fi
    if [ "$connected" = false ]; then
        handle_error "No internet connection detected. Please check your network and try again."
    fi
    
    print_success "Environment validation completed"
}

#--------------------------------
# Section: Automatic Setup
#--------------------------------

automatic_setup() {
    for step in setup_aur install_packages setup_firefox disable_services setup_fish install_optional_packages; do
        print_section_header "Running $step"
        if prompt "Do you want to proceed with $step?"; then
            log "Starting $step"
            $step
            log "Completed $step"
        else
            print_warning "Skipped $step"
        fi
    done
    setup_complete
    exit 0
}

#================================
# Section: Welcome and Help
#================================

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  -h, --help        Show this help message and exit
    -y, --yes         Assume "yes" to prompts (non-interactive)
    -n, --no          Assume "no" to prompts
            --no-color    Disable colored output

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


#================================
# Section: Main Menu
#================================

main_menu() {
    local options=(
        "Run automatic setup"
        "Set up Chaotic-AUR and update mirrors"
        "Install necessary packages"
        "Set up Firefox policies"
        "Disable unnecessary services"
        "Configure Fish shell"
        "Install optional packages"
        "Exit"
    )
    
    clear
    printf "\n${YELLOW}━━━━━━━━━━━━━━━━ System Setup Menu ━━━━━━━━━━━━━━━━${NC}\n"
    printf "${CYAN}│${NC}\n"
    
    for i in "${!options[@]}"; do
        if [ "$((i+1))" -eq "${#options[@]}" ]; then
            printf "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
        fi
        printf "${YELLOW}  [%2d]${NC} ${GREEN}%s${NC}\n" $((i+1)) "${options[$i]}"
    done
    
    printf "\n${CYAN}Enter your choice (1-${#options[@]})${NC}\n"
    read -r -p "$(echo -e "${YELLOW}>> ${NC}")" REPLY
    
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
        *) 
            printf "\n${RED}Invalid option! Press any key to continue...${NC}\n"
            read -n 1
            main_menu
            ;;
    esac
}

#--------------------------------
# Section: Helper Functions
#--------------------------------

# Ensure yay is installed (try pacman, then AUR build as fallback)
ensure_yay() {
    if command -v yay &>/dev/null; then
        return 0
    fi
    echo "Installing yay..."
    # Try pacman first (works on some Arch-based distros or if repo provides it)
    if pacman -S --needed --noconfirm yay &>/dev/null; then
        print_success "yay installed via pacman"
        return 0
    fi
    # Fallback: build yay-bin from AUR
    pacman -S --needed --noconfirm base-devel git || handle_error "Failed to install build deps for yay"
    local tmpdir
    tmpdir=$(mktemp -d /tmp/yay.XXXXXX)
    chown "$username":"$username" "$tmpdir"
    sudo -u "$username" bash -c "cd '$tmpdir' && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --noconfirm" \
        || handle_error "Failed to build/install yay from AUR"
    rm -rf "$tmpdir"
    print_success "yay installed from AUR"
}

#================================
# Section: Setup Functions
#================================

setup_aur() {
    print_section_header "Setting up Chaotic-AUR and Updating Mirrors"
    if prompt "Do you want to set up Chaotic-AUR and update mirrors?"; then
        log "Setting up Chaotic-AUR and updating mirrors"
        
        # Update package databases first
        echo "Updating package databases..."
        if ! pacman -Sy --noconfirm; then
            handle_error "Failed to update package databases"
        fi
        
        # Install required dependencies
        echo "Installing required dependencies..."
        if ! pacman -S --needed --noconfirm curl wget jq; then
            handle_error "Failed to install required dependencies"
        fi
        
        # Create backup of existing pacman.conf with timestamp
        if [ -f /etc/pacman.conf ]; then
            local backup_name="/etc/pacman.conf.backup.$(date +%Y%m%d-%H%M%S)"
            if cp /etc/pacman.conf "$backup_name"; then
                print_success "Backed up existing pacman.conf to $backup_name"
            else
                print_warning "Failed to create backup of pacman.conf"
            fi
        fi
        
        # Download new pacman.conf from GitHub
        echo "Downloading pacman.conf from GitHub repository..."
        local temp_pacman="/tmp/pacman.conf.new"
        if curl -fsSL --max-time 30 --retry 3 -o "$temp_pacman" "https://raw.githubusercontent.com/fynks/configs/refs/heads/main/backups/pacman.conf"; then
            # Validate the downloaded file contains expected content
            if grep -q "\[chaotic-aur\]" "$temp_pacman" && grep -q "Include.*chaotic-mirrorlist" "$temp_pacman"; then
                if mv "$temp_pacman" /etc/pacman.conf; then
                    print_success "Downloaded and installed new pacman.conf"
                else
                    handle_error "Failed to install new pacman.conf"
                fi
            else
                handle_error "Downloaded pacman.conf doesn't contain expected Chaotic-AUR configuration"
            fi
        else
            handle_error "Failed to download pacman.conf from GitHub repository"
        fi
        
        # Import Chaotic-AUR GPG keys
        echo "Importing Chaotic-AUR GPG keys..."
        local chaotic_keys=("FBA220DFC880C036" "3056513887B78AEB")
        local keyserver="keyserver.ubuntu.com"
        
        for key in "${chaotic_keys[@]}"; do
            echo "Importing key: $key"
            if ! pacman-key --recv-key "$key" --keyserver "$keyserver"; then
                print_warning "Failed to import key $key from $keyserver, trying alternative keyserver..."
                if ! pacman-key --recv-key "$key" --keyserver "pgp.mit.edu"; then
                    handle_error "Failed to import Chaotic-AUR key: $key"
                fi
            fi
            
            # Locally sign the key
            if ! pacman-key --lsign-key "$key"; then
                handle_error "Failed to locally sign key: $key"
            fi
        done
        
        print_success "Successfully imported and signed Chaotic-AUR keys"
        
        # Create temporary chaotic-mirrorlist if it doesn't exist
        if [ ! -f /etc/pacman.d/chaotic-mirrorlist ]; then
            echo "Creating temporary chaotic-mirrorlist..."
            mkdir -p /etc/pacman.d
            cat > /etc/pacman.d/chaotic-mirrorlist <<'EOF'
# Chaotic-AUR mirrorlist - temporary fallback
Server = https://geo-mirror.chaotic.cx/$repo/$arch
Server = https://cdn-mirror.chaotic.cx/chaotic-aur/$arch
Server = https://aur.chaotic.cx/$arch
EOF
            print_success "Created temporary chaotic-mirrorlist"
        fi
        
        # Update package databases to recognize the new repository
        echo "Updating package databases with new repositories..."
        if ! pacman -Sy --noconfirm; then
            handle_error "Failed to update package databases after adding Chaotic-AUR"
        fi
        
        # Install chaotic-keyring and chaotic-mirrorlist packages
        echo "Installing Chaotic-AUR keyring and mirrorlist packages..."
        if pacman -S --needed --noconfirm chaotic-keyring chaotic-mirrorlist; then
            print_success "Successfully installed chaotic-keyring and chaotic-mirrorlist"
        else
            print_warning "Failed to install chaotic-keyring and chaotic-mirrorlist, continuing with temporary setup"
        fi
        
        # Final system update
        echo "Performing full system update..."
        if pacman -Syyu --noconfirm; then
            print_success "Chaotic-AUR repository successfully configured and system updated"
        else
            print_warning "System update completed with some warnings"
        fi
        
        # Verify setup
        echo "Verifying Chaotic-AUR setup..."
        if pacman -Sl chaotic-aur &>/dev/null; then
            local package_count=$(pacman -Sl chaotic-aur | wc -l)
            print_success "Chaotic-AUR is working correctly with $package_count packages available"
        else
            print_warning "Chaotic-AUR setup may have issues - unable to list packages"
        fi
        
    else
        print_warning "Chaotic-AUR setup and mirror update skipped"
    fi
}

#================================
# Section: Necessary Packages
#================================

install_packages() {
    print_section_header "Installing Necessary Packages"
    if prompt "Do you want to install necessary packages?"; then
        log "Installing necessary packages"
        
        
    ensure_yay

        local package_list=(
            base-devel cmake alacritty fish plasma-wayland-session librewolf-bin ente-auth-bin
            zoxide eza vlc papers sublime-text-4 jq parallel localsend
            libreoffice-still android-tools jdownloader2 java-rhino
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


#================================
# Section: Disable Services
#================================
disable_services() {
    print_section_header "Disabling Unnecessary Services"
    if prompt "Do you want to disable unnecessary services?"; then
        log "Disabling unnecessary services"
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

#================================
# Section: Fish Configuration
#================================

setup_fish() {
    print_section_header "Setting up Fish Shell"
    if prompt "Do you want to set up Fish shell configuration?"; then
        log "Setting up Fish shell"
        
        # Create config directory if it doesn't exist
        if ! sudo -u "$username" mkdir -p "/home/$username/.config/fish"; then
            handle_error "Failed to create fish config directory"
        fi
        
        # Download fish config from GitHub
        echo "Downloading fish config from GitHub..."
        if sudo -u "$username" curl -fsSL -o "/home/$username/.config/fish/config.fish" "https://raw.githubusercontent.com/fynks/configs/refs/heads/main/backups/config.fish"; then
            print_success "Fish config downloaded and installed successfully"
        else
            handle_error "Failed to download fish config from GitHub"
        fi

        if prompt "Set fish as the default shell for $username?"; then
                local fish_path
                fish_path=$(command -v fish || true)
                if [[ -n "$fish_path" ]] && chsh -s "$fish_path" "$username"; then
                print_success "Default shell set to fish for $username"
            else
                    print_warning "Failed to change default shell; you can run: chsh -s $(command -v fish) $username"
            fi
        fi
    else
        print_warning "Fish shell setup skipped"
    fi
}

#================================
# Section: Optional Packages
#================================

install_optional_packages() {
    print_section_header "Installing Optional Packages"
    if prompt "Do you want to install optional packages?"; then
        log "Installing optional packages"
        local optional_package_list=(
            ventoy visual-studio-code-bin firefox cromite-bin nodejs npm pnpm yt-dlp telegram-desktop celluloid
        )

        echo "Installing optional packages..."
    ensure_yay
    if sudo -u "$username" yay -S --needed --noconfirm --noredownload "${optional_package_list[@]}"; then
            print_success "Optional package installation complete"
        else
            handle_error "Error installing optional packages"
        fi
    else
        print_warning "Optional package installation skipped"
    fi
}

#================================
# Section: Firefox Configuration
#================================

setup_firefox() {
    print_section_header "Setting up Firefox Policies"
    if prompt "Do you want to set up Firefox policies?"; then
        log "Setting up Firefox policies"
        
        # Create Firefox policies directory
        if ! mkdir -p /etc/firefox/policies/; then
            handle_error "Failed to create Firefox policies directory"
        fi
        
        # Download Firefox policies from GitHub
        echo "Downloading Firefox policies from GitHub..."
        if curl -fsSL -o /etc/firefox/policies/policies.json "https://raw.githubusercontent.com/fynks/configs/refs/heads/main/browsers/configs/policies.json"; then
            print_success "Firefox policies downloaded and installed successfully"
        else
            handle_error "Failed to download Firefox policies from GitHub"
        fi
    else
        print_warning "Firefox policy setup skipped"
    fi
}


#================================
# Section: Exit
#================================

setup_complete() {
    print_section_header "Setup Complete"
    echo -e "${GREEN}Arch Linux setup is complete. Please reboot your system.${NC}"
    if prompt "Do you want to reboot now?"; then
        reboot
    fi
}

#================================
# Section: Main Execution
#================================

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -y|--yes|--non-interactive)
            ASSUME_YES=true
            ;;
        -n|--no)
            ASSUME_NO=true
            ;;
        --no-color)
            COLOR_ENABLED=false
            ;;
        --)
            shift; break
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Honor NO_COLOR env var presence (https://no-color.org/)
if printenv NO_COLOR >/dev/null 2>&1; then
    COLOR_ENABLED=false
fi
if [[ "$COLOR_ENABLED" != true ]]; then
    RED=""; GREEN=""; YELLOW=""; BLUE=""; CYAN=""; NC=""
fi

# Add trap for cleanup
trap cleanup EXIT SIGINT SIGTERM
trap on_error ERR

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    handle_error "This script must be run as root. Please run with sudo or as root user."
fi

# Initialize logging after root check
init_logging

# Get the regular user's username
username="${SUDO_USER:-$USER}"
username=${username:-$(id -un)}

# If username is still empty, prompt the user to enter their username manually
if [[ -z "$username" ]]; then
    read -p "Enter your username: " username
    [[ -z "$username" ]] && handle_error "Username is required."
fi

main() {
    log "Starting setup script (repo root: $REPO_ROOT)"
    validate_environment
    welcome

    main_menu

    setup_complete
    log "Setup completed successfully"
}

main