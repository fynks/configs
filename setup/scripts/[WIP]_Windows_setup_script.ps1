# This script installs the latest version of Winget and the following programs:
# Librewolf, Brave Browser, VLC, PeaZip, Sublime Text Editor 4, and ImageGlass.

# Install the latest version of Winget
Install-Module winget -Scope CurrentUser -AllowClobber -Force

# Check if Winget is already installed
if (Get-Module -Name winget -ErrorAction SilentlyContinue) {
  # Update Winget to the latest version
  winget upgrade
}

# Install the programs
$programs = @(
  'librewolf'
  'brave-browser'
  'vlc'
  'peazip'
  'sublimetext'
  'imageglass'
)

# Install the programs with progress reporting
foreach ($program in $programs) {
  Write-Host "Installing $program..."
  winget install $program
  Write-Host "Installed $program successfully!"
}

# Display a success message
Write-Host "All programs have been installed successfully!"
