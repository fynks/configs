---
layout: doc
title: Setup
---

# Arch / EndeavourOS Setup Guide

Run these commands one at a time in a root shell. Each block is a standalone command you can paste as-is.

## Configuration

Set the user you are setting up and the lists used below:

```bash
TARGET_USER="${SUDO_USER:-$USER}"
```

Install the necessary packages:

```bash
yay --nobase-devel cmake alacritty fish plasma-wayland-session brave-origin-bin zoxide eza vlc papers sublime-text-4 jq parallel localsend
```

```bash
yay -S (android-tools jdownloader2 java-rhino libreoffice-still ventoy visual-studio-code-bin firefox librewolf nodejs npm bat yt-dlp telegram-desktop celluloid)
```

```bash
SERVICES_TO_DISABLE=(bluetooth lvm2-monitor docker ModemManager)
```

## Check the system

Confirm an Arch-based system with `pacman`:

```bash
command -v pacman > /dev/null && echo "pacman found" || echo "An Arch-based system is required"
```

Refresh the package database and check connectivity:

```bash
sudo pacman -Sy --noconfirm
```

```bash
ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1 || curl -sI --max-time 3 https://archlinux.org | grep -qi "200" && echo "online" || echo "check your connection"
```

Install the tools the later steps need:

```bash
sudo pacman -S --needed --noconfirm curl wget git sudo jq
```

## Determine the target user

If you are not sure which user to configure, detect the first regular account:

```bash
TARGET_USER="$(awk -F: '$3 >= 1000 && $3 < 65534 {print $1; exit}' /etc/passwd)"
```

```bash
echo "Configuring: $TARGET_USER"
```

## Install yay

```bash
sudo pacman -S --needed --noconfirm yay
```

If yay is not in your repositories, build `yay-bin` from the AUR:

```bash
sudo pacman -S --needed --noconfirm base-devel git
```

```bash
tmpdir="$(mktemp -d /tmp/yay.XXXXXX)" && sudo chown "$TARGET_USER":"$TARGET_USER" "$tmpdir" && sudo -u "$TARGET_USER" bash -c "cd '$tmpdir' && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --noconfirm" && rm -rf "$tmpdir"
```

## Update package mirrors

Rank the EndeavourOS mirrors:

```bash
sudo pacman -S --needed eos-rankmirrors reflector
```

```bash
sudo eos-rankmirrors
```

Rank the Arch mirrorlist directly with reflector:

```bash
sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
```

Refresh the databases and upgrade the system:

```bash
sudo pacman -Syu
```

## Chaotic AUR

Import and sign the keyring key:

```bash
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
```

```bash
sudo pacman-key --lsign-key 3056513887B78AEB
```

Install the keyring and mirrorlist packages:

```bash
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```

Add this to the end of `/etc/pacman.conf`:

```ini
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```

Refresh the databases:

```bash
sudo pacman -Sy
```

## Install the necessary packages

```bash
sudo -u "$TARGET_USER" yay -S --needed --noconfirm "${NECESSARY_PACKAGES[@]}"
```

## Disable unnecessary services

```bash
for service in "${SERVICES_TO_DISABLE[@]}"; do systemctl list-unit-files | grep -q "^${service}\.service" && sudo systemctl disable --now "$service"; done
```

Check what is still enabled:

```bash
systemctl is-enabled bluetooth lvm2-monitor docker ModemManager 2>/dev/null
```

## Configure Fish

Create the config directory and download the config:

```bash
sudo -u "$TARGET_USER" mkdir -p "/home/$TARGET_USER/.config/fish"
```

```bash
sudo -u "$TARGET_USER" curl -fsSL -o "/home/$TARGET_USER/.config/fish/config.fish" https://raw.githubusercontent.com/fynks/configs/refs/heads/main/backups/config.fish
```

Add Fish to the list of valid shells and make it the default:

```bash
command -v fish | grep -qxF - /etc/shells || echo "$(command -v fish)" | sudo tee -a /etc/shells
```

```bash
sudo chsh -s "$(command -v fish)" "$TARGET_USER"
```

Log out and back in for the shell change to take effect.

## Install the optional packages

```bash
sudo -u "$TARGET_USER" yay -S --needed --noconfirm "${OPTIONAL_PACKAGES[@]}"
```

Install Bun:

```bash
sudo -u "$TARGET_USER" bash -c 'curl -fsSL https://bun.com/install | bash'
```

## Configure Firefox policies

```bash
sudo mkdir -p /etc/firefox/policies
```

```bash
sudo curl -fsSL -o /etc/firefox/policies/policies.json https://raw.githubusercontent.com/fynks/configs/refs/heads/main/browsers/configs/policies.json
```

Restore the uBlock Origin config from [the repo](https://raw.githubusercontent.com/fynks/configs/refs/heads/main/browsers/extensions/u_block_origin_configs.txt) in the extension's settings.

## Restore keyboard shortcuts

Download the KDE shortcut scheme:

```bash
wget https://raw.githubusercontent.com/fynks/configs/refs/heads/main/backups/kde-shortcuts.kksrc
```

In System Settings, open **Keyboard → Shortcuts**, choose **Import Scheme...**, select the downloaded file and click **Apply**. Press `Alt + F2` and type `shortcuts` to open it quickly.

## Improve boot time

```bash
systemd-analyze
```

```bash
sudo systemctl disable bluetooth.service
```

```bash
sudo systemctl disable cups.service
```

Only disable `cups.service` if you do not use a printer.

## Check the result

Verify the key tools and the services you disabled:

```bash
fish --version && bun --version && yay --version
```

```bash
systemctl is-enabled bluetooth lvm2-monitor docker ModemManager 2>/dev/null
```

Reboot when you are ready:

```bash
sudo reboot
```

## Troubleshooting

### GPG key errors

```bash
sudo pacman-key --refresh-keys
```

If the keyring is broken, rebuild it:

```bash
sudo pacman -S --needed archlinux-keyring endeavouros-keyring
```

```bash
sudo rm -rf /etc/pacman.d/gnupg && sudo pacman-key --init && sudo pacman-key --populate archlinux endeavouros
```
