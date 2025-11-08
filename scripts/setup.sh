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

# Tracking arrays for summary
declare -a INSTALLED_PACKAGES=()
declare -a MODIFIED_FILES=()
declare -a DISABLED_SERVICES=()
declare -a ERRORS=()

# Package groups
declare -a NECESSARY_PACKAGES=(
    base-devel cmake alacritty fish plasma-wayland-session librewolf-bin ente-auth-bin
    zoxide eza vlc papers sublime-text-4 jq parallel localsend
    libreoffice-still android-tools jdownloader2 java-rhino
)

declare -a OPTIONAL_PACKAGES=(
    ventoy visual-studio-code-bin firefox brave-browser-beta nodejs npm pnpm bat 
    yt-dlp proton-vpn-gtk-app telegram-desktop celluloid
)

declare -a SERVICES_TO_DISABLE=(
    bluetooth
    lvm2-monitor
    docker
    ModemManager
)


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
    local line="${2:-${BASH_LINENO[0]}}"
    local func="${3:-${FUNCNAME[1]}}"
    local timestamp=$(date '+%H:%M:%S')
    
    printf "\n${RED}━━━━━━━━━━━━━━━━ ERROR ━━━━━━━━━━━━━━━━${NC}\n"
    printf "${RED}│${NC} ⛔ %s\n" "$error_msg"
    printf "${RED}│${NC} 📍 Function: %s (line %s)\n" "$func" "$line"
    printf "${RED}│${NC} ⏰ Time: %s\n" "$timestamp"
    printf "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n\n"
    
    log "$error_msg [Function: $func, Line: $line]" "ERROR"
    ERRORS+=("$error_msg (in $func at line $line)")
    
    cleanup
    exit 1
}

# Error trap helper to surface failing command
on_error() {
    local exit_code=$?
    local cmd=${BASH_COMMAND:-unknown}
    local line=${BASH_LINENO[0]}
    handle_error "Command failed (exit $exit_code): $cmd" "$line" "${FUNCNAME[1]}"
}

print_success() {
    local msg="$1"
    printf "\n${GREEN}✓${NC} ${GREEN}%s${NC}\n" "$msg"
}

print_warning() {
    local msg="$1"
    printf "\n${YELLOW}⚠${NC} ${YELLOW}%s${NC}\n" "$msg"
    ERRORS+=("WARNING: $msg")
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
    jobs -p | xargs -r kill &>/dev/null 2>&1 || true
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
        if command -v curl &>/dev/null && curl -sI --max-time 3 https://archlinux.org 2>/dev/null | grep -qi "200"; then
            connected=true
        fi
    fi
    if [ "$connected" = false ]; then
        handle_error "No internet connection detected. Please check your network and try again."
    fi
    
    print_success "Environment validation completed"
}

#--------------------------------
# Section: Username Detection
#--------------------------------
get_target_user() {
    local user="${SUDO_USER:-}"
    
    # If SUDO_USER is empty or root, try other methods
    if [[ -z "$user" ]] || [[ "$user" == "root" ]]; then
        user=$(logname 2>/dev/null || true)
    fi
    
    # Try getting from who command
    if [[ -z "$user" ]] || [[ "$user" == "root" ]]; then
        user=$(who am i | awk '{print $1}' 2>/dev/null || true)
    fi
    
    # Last resort: get first non-system user from /etc/passwd
    if [[ -z "$user" ]] || [[ "$user" == "root" ]]; then
        user=$(awk -F: '$3 >= 1000 && $3 < 65534 {print $1; exit}' /etc/passwd)
    fi
    
    # If still empty, prompt the user
    if [[ -z "$user" ]]; then
        read -p "Enter your username: " user
    fi
    
    # Validate user exists and is not root
    if [[ -z "$user" ]] || [[ "$user" == "root" ]]; then
        handle_error "Invalid username. Cannot proceed with 'root' user."
    fi
    
    if ! id "$user" &>/dev/null; then
        handle_error "User '$user' does not exist on this system."
    fi
    
    # Verify user has a valid home directory
    local user_home
    user_home=$(eval echo "~$user")
    if [[ ! -d "$user_home" ]]; then
        handle_error "Home directory for user '$user' does not exist: $user_home"
    fi
    
    echo "$user"
}

#--------------------------------
# Section: Package Management
#--------------------------------
check_installed_packages() {
    local -n pkg_array=$1
    local -a missing=()
    
    # Get all installed packages in one query (faster than multiple calls)
    local installed
    installed=$(pacman -Qq 2>/dev/null || true)
    
    for pkg in "${pkg_array[@]}"; do
        # Handle AUR packages (with -bin, -git suffixes)
        if ! grep -qxF "$pkg" <<<"$installed"; then
            missing+=("$pkg")
        fi
    done
    
    echo "${missing[@]}"
}

# Ensure yay is installed (try pacman, then AUR build as fallback)
ensure_yay() {
    local target_user="${1:-$username}"
    
    if command -v yay &>/dev/null; then
        print_success "yay is already installed"
        return 0
    fi
    
    echo "Installing yay AUR helper..."
    log "Installing yay for user: $target_user"
    
    # Validate user exists before proceeding
    if ! id "$target_user" &>/dev/null; then
        handle_error "User '$target_user' does not exist, cannot install yay"
    fi
    
    # Try pacman first (works on some Arch-based distros)
    if pacman -S --needed --noconfirm yay &>/dev/null; then
        print_success "yay installed via pacman"
        return 0
    fi
    
    # Fallback: build yay-bin from AUR
    echo "Building yay from AUR..."
    
    # Install build dependencies
    if ! pacman -S --needed --noconfirm base-devel git; then
        handle_error "Failed to install build dependencies for yay"
    fi
    
    local tmpdir
    tmpdir=$(mktemp -d /tmp/yay.XXXXXX)
    
    # Ensure the temp directory has correct permissions
    chown "$target_user":"$target_user" "$tmpdir"
    chmod 755 "$tmpdir"
    
    # Build and install as the target user
    if sudo -u "$target_user" bash -c "
        set -e
        cd '$tmpdir' || exit 1
        git clone https://aur.archlinux.org/yay-bin.git || exit 1
        cd yay-bin || exit 1
        makepkg -si --noconfirm || exit 1
    "; then
        rm -rf "$tmpdir"
        print_success "yay installed from AUR"
        return 0
    else
        rm -rf "$tmpdir"
        handle_error "Failed to build/install yay from AUR"
    fi
}

install_package_group() {
    local group_name="$1"
    local user="$2"
    shift 2
    local packages=("$@")
    
    print_section_header "Installing $group_name"
    
    if [[ "$ASSUME_YES" != true ]]; then
        if ! prompt "Install $group_name (${#packages[@]} packages)?"; then
            print_warning "$group_name installation skipped"
            return 0
        fi
    fi
    
    # Check which packages are already installed
    local missing
    missing=$(check_installed_packages packages)
    
    if [[ -z "$missing" ]]; then
        print_success "All $group_name packages already installed"
        return 0
    fi
    
    echo -e "${CYAN}Packages to install:${NC} $missing"
    log "Installing $group_name: $missing"
    
    # Install packages
    if sudo -u "$user" yay -S --needed --noconfirm --noredownload $missing; then
        print_success "$group_name installation complete"
        # Track installed packages
        for pkg in $missing; do
            INSTALLED_PACKAGES+=("$pkg")
        done
        return 0
    else
        local error_msg="Failed to install $group_name"
        print_warning "$error_msg"
        ERRORS+=("$error_msg")
        return 1
    fi
}

#--------------------------------
# Section: Automatic Setup
#--------------------------------
automatic_setup() {
    print_section_header "Automatic Setup Mode"
    
    if [[ "$ASSUME_YES" != true ]]; then
        echo -e "${CYAN}This will run all setup steps sequentially.${NC}"
        echo -e "${CYAN}You can still skip individual steps.${NC}\n"
        if ! prompt "Continue with automatic setup?"; then
            print_warning "Automatic setup cancelled"
            return
        fi
    fi
    
    local steps=(
        "setup_aur:Setting up Chaotic-AUR"
        "install_packages:Installing necessary packages"
        "setup_firefox:Configuring Firefox policies"
        "disable_services:Disabling unnecessary services"
        "setup_fish:Configuring Fish shell"
        "install_optional_packages:Installing optional packages"
    )
    
    local total_steps=${#steps[@]}
    local current_step=0
    
    for step_info in "${steps[@]}"; do
        ((current_step++))
        
        IFS=':' read -r step_func step_desc <<< "$step_info"
        
        printf "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
        printf "${BLUE}Step %d/%d: %s${NC}\n" "$current_step" "$total_steps" "$step_desc"
        printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n\n"
        
        if [[ "$ASSUME_YES" == true ]]; then
            log "Auto-running $step_func"
            $step_func || print_warning "Step $step_func completed with warnings"
        elif prompt "Proceed with $step_desc?"; then
            log "Starting $step_func"
            $step_func || print_warning "Step $step_func completed with warnings"
            log "Completed $step_func"
        else
            print_warning "Skipped $step_func"
        fi
    done
    
    show_summary
    setup_complete
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
  --no-color        Disable colored output

This script helps you set up various components of your Manjaro/Arch Linux system.

Features:
  - Chaotic-AUR repository setup
  - Batch package installation
  - Firefox policy configuration
  - Service management
  - Fish shell setup
  - Installation summary and error tracking

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
    echo -e "${YELLOW} #  Manjaro/Arch Linux Setup Script          ${NC}"
    echo -e "${YELLOW} #  Improved Version with Enhanced Features  ${NC}"
    echo -e "${YELLOW} #--------------------------------------------${NC}"
    echo ""
    echo -e "${BLUE}Welcome to the Manjaro/Arch Linux Setup script!${NC}"
    echo -e "${CYAN}Target user: ${GREEN}$username${NC}"
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
        "Show installation summary"
        "Exit"
    )
    
    while true; do
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
            8) show_summary ;;
            9) 
                show_summary
                setup_complete
                exit 0
                ;;
            *) 
                printf "\n${RED}Invalid option! Press any key to continue...${NC}\n"
                read -n 1
                ;;
        esac
        
        # Pause after each operation (except exit)
        if [[ "$REPLY" != "9" ]]; then
            printf "\n${CYAN}Press any key to return to menu...${NC}\n"
            read -n 1
        fi
    done
}

#================================
# Section: Setup Functions
#================================

setup_aur() {
    print_section_header "Setting up Chaotic-AUR and Updating Mirrors"
    
    if [[ "$ASSUME_YES" != true ]]; then
        if ! prompt "Do you want to set up Chaotic-AUR and update mirrors?"; then
            print_warning "Chaotic-AUR setup and mirror update skipped"
            return 0
        fi
    fi
    
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
            MODIFIED_FILES+=("/etc/pacman.conf")
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
        MODIFIED_FILES+=("/etc/pacman.d/chaotic-mirrorlist")
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
        INSTALLED_PACKAGES+=("chaotic-keyring" "chaotic-mirrorlist")
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
}

#================================
# Section: Necessary Packages
#================================

install_packages() {
    log "Installing necessary packages"
    ensure_yay "$username"
    install_package_group "Necessary Packages" "$username" "${NECESSARY_PACKAGES[@]}"
}


#================================
# Section: Disable Services
#================================
disable_services() {
    print_section_header "Disabling Unnecessary Services"
    
    if [[ "$ASSUME_YES" != true ]]; then
        if ! prompt "Do you want to disable unnecessary services?"; then
            print_warning "Service disabling skipped"
            return 0
        fi
    fi
    
    log "Disabling unnecessary services"

    for service in "${SERVICES_TO_DISABLE[@]}"; do
        # Check if service exists
        if ! systemctl list-unit-files | grep -q "^${service}\.service"; then
            print_warning "$service service not found on this system"
            continue
        fi
        
        if systemctl is-enabled --quiet "$service" 2>/dev/null; then
            echo "Disabling $service service..."
            if systemctl stop "$service" 2>/dev/null && systemctl disable "$service" 2>/dev/null; then
                print_success "$service service disabled"
                DISABLED_SERVICES+=("$service")
            else
                print_warning "Failed to disable $service service"
            fi
        else
            echo "$service service is already disabled"
        fi
    done
    
    if [[ ${#DISABLED_SERVICES[@]} -eq 0 ]]; then
        print_success "No services needed to be disabled"
    else
        print_success "Disabled ${#DISABLED_SERVICES[@]} service(s)"
    fi
}

#================================
# Section: Fish Configuration
#================================

setup_fish() {
    print_section_header "Setting up Fish Shell"
    
    if [[ "$ASSUME_YES" != true ]]; then
        if ! prompt "Do you want to set up Fish shell configuration?"; then
            print_warning "Fish shell setup skipped"
            return 0
        fi
    fi
    
    log "Setting up Fish shell"
    
    local user_home
    user_home=$(eval echo "~$username")
    local fish_config_dir="$user_home/.config/fish"
    local fish_config_file="$fish_config_dir/config.fish"
    
    # Create config directory if it doesn't exist
    if ! sudo -u "$username" mkdir -p "$fish_config_dir"; then
        handle_error "Failed to create fish config directory"
    fi
    
    # Backup existing config if present
    if [[ -f "$fish_config_file" ]]; then
        local backup_name="$fish_config_file.backup.$(date +%Y%m%d-%H%M%S)"
        if sudo -u "$username" cp "$fish_config_file" "$backup_name"; then
            print_success "Backed up existing fish config to $backup_name"
        fi
    fi
    
    # Download fish config from GitHub
    echo "Downloading fish config from GitHub..."
    if sudo -u "$username" curl -fsSL -o "$fish_config_file" "https://raw.githubusercontent.com/fynks/configs/refs/heads/main/backups/config.fish"; then
        print_success "Fish config downloaded and installed successfully"
        MODIFIED_FILES+=("$fish_config_file")
    else
        handle_error "Failed to download fish config from GitHub"
    fi

    if [[ "$ASSUME_YES" == true ]] || prompt "Set fish as the default shell for $username?"; then
        local fish_path
        fish_path=$(command -v fish || true)
        
        if [[ -z "$fish_path" ]]; then
            print_warning "Fish shell not found in PATH"
            return 1
        fi
        
        # Check if fish is in /etc/shells
        if ! grep -qxF "$fish_path" /etc/shells; then
            echo "Adding fish to /etc/shells..."
            echo "$fish_path" >> /etc/shells
        fi
        
        if chsh -s "$fish_path" "$username"; then
            print_success "Default shell set to fish for $username"
        else
            print_warning "Failed to change default shell. You can manually run: chsh -s $fish_path"
        fi
    fi
}

#================================
# Section: Optional Packages
#================================

install_optional_packages() {
    log "Installing optional packages"
    ensure_yay "$username"
    install_package_group "Optional Packages" "$username" "${OPTIONAL_PACKAGES[@]}"
}

#================================
# Section: Firefox Configuration
#================================

setup_firefox() {
    print_section_header "Setting up Firefox Policies"
    
    if [[ "$ASSUME_YES" != true ]]; then
        if ! prompt "Do you want to set up Firefox policies?"; then
            print_warning "Firefox policy setup skipped"
            return 0
        fi
    fi
    
    log "Setting up Firefox policies"
    
    local firefox_policies_dir="/etc/firefox/policies"
    local firefox_policies_file="$firefox_policies_dir/policies.json"
    
    # Create Firefox policies directory
    if ! mkdir -p "$firefox_policies_dir"; then
        handle_error "Failed to create Firefox policies directory"
    fi
    
    # Backup existing policies if present
    if [[ -f "$firefox_policies_file" ]]; then
        local backup_name="$firefox_policies_file.backup.$(date +%Y%m%d-%H%M%S)"
        if cp "$firefox_policies_file" "$backup_name"; then
            print_success "Backed up existing Firefox policies to $backup_name"
        fi
    fi
    
    # Download Firefox policies from GitHub
    echo "Downloading Firefox policies from GitHub..."
    if curl -fsSL -o "$firefox_policies_file" "https://raw.githubusercontent.com/fynks/configs/refs/heads/main/browsers/configs/policies.json"; then
        print_success "Firefox policies downloaded and installed successfully"
        MODIFIED_FILES+=("$firefox_policies_file")
    else
        handle_error "Failed to download Firefox policies from GitHub"
    fi
}


#================================
# Section: Summary
#================================

show_summary() {
    print_section_header "Installation Summary"
    
    echo -e "${CYAN}Packages Installed:${NC} ${GREEN}${#INSTALLED_PACKAGES[@]}${NC}"
    if [[ ${#INSTALLED_PACKAGES[@]} -gt 0 ]] && [[ ${#INSTALLED_PACKAGES[@]} -le 10 ]]; then
        for pkg in "${INSTALLED_PACKAGES[@]}"; do
            echo -e "   ${GREEN}•${NC} $pkg"
        done
    elif [[ ${#INSTALLED_PACKAGES[@]} -gt 10 ]]; then
        echo -e "   ${YELLOW}(Too many to list - check log file)${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}Files Modified:${NC} ${GREEN}${#MODIFIED_FILES[@]}${NC}"
    if [[ ${#MODIFIED_FILES[@]} -gt 0 ]]; then
        for file in "${MODIFIED_FILES[@]}"; do
            echo -e "   ${GREEN}•${NC} $file"
        done
    fi
    
    echo ""
    echo -e "${CYAN}Services Disabled:${NC} ${GREEN}${#DISABLED_SERVICES[@]}${NC}"
    if [[ ${#DISABLED_SERVICES[@]} -gt 0 ]]; then
        for service in "${DISABLED_SERVICES[@]}"; do
            echo -e "   ${GREEN}•${NC} $service"
        done
    fi
    
    echo ""
    echo -e "${CYAN}Log File:${NC} ${BLUE}$LOGFILE${NC}"
    
    if [[ ${#ERRORS[@]} -gt 0 ]]; then
        echo ""
        echo -e "${YELLOW}⚠ Warnings/Errors (${#ERRORS[@]}):${NC}"
        for error in "${ERRORS[@]}"; do
            echo -e "   ${YELLOW}•${NC} $error"
        done
    else
        echo ""
        echo -e "${GREEN}✓ No errors or warnings encountered${NC}"
    fi
    
    echo ""
}


#================================
# Section: Exit
#================================

setup_complete() {
    print_section_header "Setup Complete"
    echo -e "${GREEN}Manjaro/Arch Linux setup is complete!${NC}"
    echo ""
    
    # Show summary one more time
    show_summary
    
    echo ""
    if [[ "$ASSUME_YES" == true ]] || prompt "Do you want to reboot now?"; then
        echo -e "${YELLOW}Rebooting in 5 seconds... (Press Ctrl+C to cancel)${NC}"
        sleep 5
        reboot
    else
        echo -e "${CYAN}Please reboot your system when convenient.${NC}"
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

# Get the target user with improved detection
username=$(get_target_user)

main() {
    log "Starting setup script (repo root: $REPO_ROOT, user: $username)"
    validate_environment
    welcome

    # If running in non-interactive mode, go straight to automatic setup
    if [[ "$ASSUME_YES" == true ]]; then
        automatic_setup
    else
        main_menu
    fi

    log "Setup completed successfully"
}

main
