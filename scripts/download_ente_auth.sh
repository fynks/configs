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
LOGFILE="/var/log/download-ente-auth.log"

# Configuration files
CONFIG_DIR="$HOME/.config/ente-auth"
CONFIG_FILE="$CONFIG_DIR/config"
VERSION_FILE="$CONFIG_DIR/version"
APP_PREFIX="ente-auth"

#================================
# Section: Core Functions
#================================

#--------------------------------
# Section: UI Elements
#--------------------------------
prompt() {
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
    local title="$1"
    printf "\n${YELLOW}━━━━━━━━━━━━━━━━ %s ━━━━━━━━━━━━━━━━${NC}\n" "$title"
    printf "${CYAN}│${NC}\n"
}

handle_error() {
    local error_msg="$1"
    printf "\n${RED}━━━━━━━━━━━━━━━━ ERROR ━━━━━━━━━━━━━━━━${NC}\n"
    printf "${RED}│${NC} ⛔ %s\n" "$error_msg"
    printf "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n\n"
    log "$error_msg" "ERROR"
    exit 1
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

#--------------------------------
# Section: Configuration Functions
#--------------------------------

setup_config() {
    # Create config directory if it doesn't exist
    mkdir -p "$CONFIG_DIR"
    
    # If config file doesn't exist, create it
    if [ ! -f "$CONFIG_FILE" ]; then
        print_section_header "First Time Setup"
        printf "${CYAN}Please enter the username for installation:${NC}\n"
        read -p "Username: " username
        
        # Verify the username exists
        if ! id "$username" >/dev/null 2>&1; then
            handle_error "User '$username' does not exist. Please provide a valid username."
        fi
        
        # Save username to config
        echo "USERNAME=$username" > "$CONFIG_FILE"
        print_success "Configuration saved for user: $username"
    fi
}

get_config_username() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        echo "$USERNAME"
    else
        handle_error "Configuration file not found. Please run setup first."
    fi
}

#--------------------------------
# Section: Version Handling Functions
#--------------------------------

get_last_downloaded_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    fi
}

get_latest_version_info() {
    local API_URL="https://api.github.com/repos/ente-io/ente/releases/latest"
    local RELEASE_DATA
    RELEASE_DATA=$(curl -s "$API_URL")

    if [ $? -ne 0 ]; then
        handle_error "Failed to fetch Ente release information"
    fi
    echo "$RELEASE_DATA"
}

extract_version_from_release_data() {
    local release_data="$1"
    echo "$release_data" | jq -r '.tag_name' | sed 's/^v//' # Remove leading 'v' if present in tag
}

extract_download_url_from_release_data() {
    local release_data="$1"
    echo "$release_data" | \
        jq -r '.assets[] | select(.name | contains("x86_64.AppImage")) | .browser_download_url'
}

update_version_file() {
    local version="$1"
    echo "$version" > "$VERSION_FILE"
}

#================================
# Section: Ente Auth Download Function
#================================

download_ente_auth() {
    local username=$(get_config_username)
    local APP_DIR="/home/$username/Applications"
    
    print_section_header "Downloading Ente Auth"

    local last_downloaded_version=$(get_last_downloaded_version)
    local latest_release_data=$(get_latest_version_info)
    local latest_version=$(extract_version_from_release_data "$latest_release_data")
    local download_url=$(extract_download_url_from_release_data "$latest_release_data")

    printf "\n${CYAN}Ente Auth Version Information:${NC}\n"
    printf "  Installation user: ${YELLOW}${username}${NC}\n"
    if [ -n "$last_downloaded_version" ]; then
        printf "  Last downloaded version: ${YELLOW}v${last_downloaded_version}${NC}\n"
    else
        printf "  Last downloaded version: ${YELLOW}None${NC}\n"
    fi
    printf "  Latest version available: ${YELLOW}v${latest_version}${NC}\n\n"

    if ! prompt "Would you like to download the latest version (v${latest_version})?"; then
        print_warning "Ente Auth download skipped."
        return 0
    fi

    log "Downloading Ente Auth v$latest_version"

    if [ -z "$download_url" ]; then
        handle_error "Could not find Ente AppImage download URL for version v$latest_version"
    fi

    local filename="${APP_PREFIX}-v${latest_version}-x86_64.AppImage"
    local download_path="$APP_DIR"

    # Create Applications directory if it doesn't exist
    mkdir -p "$download_path"

    # Download the AppImage
    echo "Downloading $filename..."
    if curl -L -o "$download_path/$filename" "$download_url"; then
        chmod +x "$download_path/$filename"
        update_version_file "$latest_version"
        print_success "Successfully downloaded $filename to $download_path (version v$latest_version)"
    else
        handle_error "Ente Auth download failed for version v$latest_version"
    fi
}

#================================
# Section: Main Execution
#================================

main() {
    log "Starting Ente Auth download script"
    
    # Check for required dependencies
    local deps=(curl jq grep sed)
    for dep in "${deps[@]}"; do
        command -v "$dep" >/dev/null 2>&1 || { 
            handle_error "$dep is not installed. Please install $dep to proceed."
            exit 99
        }
    done

    # Setup configuration if first run
    setup_config
    
    download_ente_auth

    log "Ente Auth download script completed"
}

main