---
layout: doc
title: Setup
---

# Manjaro Linux Setup Guide

## Setup Script
```bash
git clone https://github.com/fynks/configs.git && \
cd configs/scripts/ && \
sudo chmod +x ./setup.sh && \
sudo ./setup.sh
```

## Update Package Mirrors
```bash
# Update mirrors and refresh package database
sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syu
```

::: details **What this does:**
- `--fasttrack 5`: Tests and ranks the 5 fastest mirrors
- `-Syu`: Syncs package databases and updates all packages
:::

## Chaotic AUR Setup

1. **Add Chaotic AUR keyring:**

```bash
# Import the primary key
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com

# Locally sign the key
sudo pacman-key --lsign-key 3056513887B78AEB
```

2. **Install Chaotic AUR packages:**

```bash
# Install keyring and mirrorlist
sudo pacman -U \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```

3. **Enable Chaotic AUR repository:**

Add the following to the end of `/etc/pacman.conf`:

```ini
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```

4. **Update package database:**

```bash
sudo pacman -Sy
```

## KDE Desktop Configuration

### Restore Keyboard Shortcuts

Follow these steps to restore your custom keyboard shortcuts:

1. **Download the configuration file:**
   ```bash
   wget https://raw.githubusercontent.com/fynks/configs/refs/heads/main/backups/kde-shortcuts.kksrc
   ```

2. **Import the shortcuts:**
   - Open **System Settings** (Settings app)
   - Navigate to **Shortcuts** (or **Keyboard** → **Shortcuts**)
   - Click **Import Scheme...** or **Import**
   - Select the downloaded `kde-shortcuts.kksrc` file
   - Click **Apply** to activate the shortcuts

::: tip
You can also access System Settings quickly by pressing `Alt + F2` and typing "shortcuts"
:::

### Improve Boot Time

```bash
# Analyze boot time
systemd-analyze

# Disable unnecessary services (example)
sudo systemctl disable bluetooth.service
sudo systemctl disable cups.service  # Only if you don't use printers
```

## Troubleshooting

### GPG Key Errors

If you encounter GPG key errors:

```bash
# Refresh all keys
sudo pacman-key --refresh-keys

# Reset keyring if needed
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux manjaro
```


