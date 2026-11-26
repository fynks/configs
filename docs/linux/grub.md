---
layout: doc
title: GRUB Bootloader
---

# GRUB Bootloader Guide

## Enable GRUB Menu

If the GRUB menu is not showing during boot (common on single-OS systems):

### Method 1: Show Menu Permanently
1. Edit GRUB configuration:
   ```bash
   sudo nano /etc/default/grub
   ```

2. Modify these settings:
   ```bash
   GRUB_TIMEOUT_STYLE=menu
   GRUB_TIMEOUT=10
   ```

3. Update GRUB configuration:
   ```bash
   sudo update-grub
   ```

### Method 2: Show Menu Temporarily
Hold `Shift` (BIOS) or `Esc` (UEFI) during boot to access the GRUB menu.

## Restore GRUB After Windows Installation

Windows installation often overwrites the bootloader. Here's how to restore GRUB:

### For Manjaro/Arch-based Systems
1. Boot into Manjaro live environment
2. Open terminal and access your system via chroot:
   ```bash
   sudo manjaro-chroot -a
   ```
3. Install GRUB to the main drive:
   ```bash
   grub-install /dev/sda
   ```
   > **Note:** Replace `/dev/sda` with your actual boot drive (check with `lsblk`)

4. Verify installation:
   ```bash
   grub-install --recheck /dev/sda
   ```

5. Update GRUB configuration:
   ```bash
   update-grub
   ```

6. Exit chroot and reboot:
   ```bash
   exit
   reboot
   ```


## GRUB Configuration

The main GRUB configuration file is `/etc/default/grub`. Here are common settings:

### Key Configuration Options
```bash
# Timeout before default boot (seconds)
GRUB_TIMEOUT=10

# Default boot entry (0 = first entry)
GRUB_DEFAULT=0

# Boot menu display style
GRUB_TIMEOUT_STYLE=menu  # or 'hidden'

# Remember last selected entry
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true

# Disable OS prober (faster boot, manual entries only)
GRUB_DISABLE_OS_PROBER=false
```

### After making changes, always update GRUB:
```bash
sudo update-grub
```

## Troubleshooting

### Common GRUB Issues and Solutions

#### 1. GRUB Rescue Mode
If you see `grub rescue>` prompt:

```bash
# List available partitions
ls

# Find your Linux partition (look for ext4)
ls (hd0,gpt2)/

# Set root and boot
set root=(hd0,gpt2)
set prefix=(hd0,gpt2)/boot/grub
insmod normal
normal
```


#### 2. Fix Corrupted GRUB Configuration
```bash
# Regenerate GRUB configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Or use update-grub (Ubuntu/Debian)
sudo update-grub
```

#### 3. Check Boot Drive
```bash
# List block devices
lsblk

# Check EFI partition (UEFI systems)
sudo efibootmgr -v

# Mount EFI partition
sudo mount /dev/sda1 /boot/efi
```

#### 4. GRUB Not Detecting Windows
```bash
# Install os-prober
sudo apt install os-prober

# Enable OS detection
sudo nano /etc/default/grub
# Set: GRUB_DISABLE_OS_PROBER=false

# Update GRUB
sudo update-grub
```

### Useful GRUB Commands

```bash
# Install GRUB to specific device
sudo grub-install /dev/sda

# Install GRUB for UEFI
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi

# Generate configuration file
sudo grub-mkconfig -o /boot/grub/grub.cfg

# List GRUB modules
ls /usr/lib/grub/x86_64-pc/

# Check GRUB version
grub-install --version
```




