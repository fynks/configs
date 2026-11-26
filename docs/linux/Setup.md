---
layout: doc
title: Setup
---

# Arch / EndeavourOS Setup Guide


## Configuration

Refresh the package database:

```bash
sudo pacman -Sy --noconfirm
```

```bash
sudo pacman -S --needed --noconfirm curl wget git sudo jq
```

Install yay:

```bash
sudo pacman -S --needed --noconfirm yay
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


## Install Packages

Install the necessary packages:

```bash
yay -S --needed --noconfirm base-devel cmake alacritty fish plasma-wayland-session brave-origin-bin zoxide eza vlc papers sublime-text-4 jq parallel localsend
```

Disable services

```bash
sudo systemctl disable --now bluetooth.service cups.service lvm2-monitor docker ModemManager
```

## Configure Fish

Create the config directory and download the config:

```bash
mkdir -p "/home/$TARGET_USER/.config/fish"
```

```bash
sudo curl -fsSL -o "/home/$TARGET_USER/.config/fish/config.fish" https://raw.githubusercontent.com/fynks/configs/refs/heads/main/backups/config.fish
```

Add Fish to the list of valid shells and make it the default:

```bash
command -v fish | grep -qxF - /etc/shells || echo "$(command -v fish)" | sudo tee -a /etc/shells
```

```bash
sudo chsh -s "$(command -v fish)"
```

Log out and back in for the shell change to take effect.

## Install the optional packages

```bash
yay -S --needed --noconfirm android-tools jdownloader2 java-rhino libreoffice-still ventoy visual-studio-code-bin firefox librewolf nodejs npm bat yt-dlp telegram-desktop celluloid
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
