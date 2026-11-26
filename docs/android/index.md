---
layout: doc
title: Android
---
# Android Setup

## Recommended Applications
### Play Store

#### Security & Privacy
- [Bitwarden](https://play.google.com/store/apps/details?id=com.x8bit.bitwarden) - Password manager
- [SimpleLogin](https://play.google.com/store/apps/details?id=io.simplelogin.android) - Email protection
- [AdGuard VPN](https://play.google.com/store/apps/details?id=com.adguard.vpn) - VPN service
- [Ente Auth](https://play.google.com/store/apps/details?id=io.ente.auth) - 2FA authenticator

#### Browsers
- [Brave](https://play.google.com/store/apps/details?id=com.brave.browser) - Privacy-focused browser
  - [Beta Version](https://play.google.com/store/apps/details?id=com.brave.browser_beta)
  - [Nightly Version](https://play.google.com/store/apps/details?id=com.brave.browser_nightly)

#### Communication
- [Proton Mail](https://play.google.com/store/apps/details?id=ch.protonmail.android) - Encrypted email
- [Tuta](https://play.google.com/store/apps/details?id=de.tutao.tutanota) - Secure email
- [Facebook](https://play.google.com/store/apps/details?id=com.facebook.katana) - Social network
- [Snapchat](https://play.google.com/store/apps/details?id=com.snapchat.android) - Photo messaging

#### Productivity
- [Inoreader](https://play.google.com/store/apps/details?id=com.innologica.inoreader) - RSS reader
- [ONLYOFFICE Documents](https://play.google.com/store/apps/details?id=com.onlyoffice.documents) - Office suite

#### Media
- [VLC](https://play.google.com/store/apps/details?id=org.videolan.vlc) - Media player
- [Poweramp](https://play.google.com/store/apps/details?id=com.maxmpz.audioplayer) - Music player
  - [Full Version Unlocker](https://play.google.com/store/apps/details?id=com.maxmpz.audioplayer.unlock)

#### Utilities
- [1DM+](https://play.google.com/store/apps/details?id=idm.internet.download.manager.plus) - Download manager
- [Microsoft SwiftKey Beta](https://play.google.com/store/apps/details?id=com.touchtype.swiftkey.beta) - Keyboard

## Flash a custom recovery
```sh
fastboot devices
```
```sh
fastboot flash recovery recovery.img
```
> ⚠️ Warning: Never reboot into recovery using fastboot command

## Media Management
### Finding .m4a songs from terminal
```sh
find . -type f -name "*.m4a" > m4a.txt
```
### Find all media files
```sh
find . -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.wav" \) > media_files.txt
```

## HyperOS Debloating
### Automated Method
```bash
git clone https://github.com/fynks/android-debloater.git
cd android-debloater
chmod +x debloat.sh
./debloat.sh
```

### Manual Debloating Guide
#### Safe to Remove
- Analytics
- App Vault
- Backup
- Browser
- CatchLog
- Cleaner
- Downloads
- FM Radio
- Facebook
- Feedback
- Games
- GetApps [Only for Global ROM]
- MSA
- Market Feedback Agent
- Mail
- Market Feedback Agent
- Meta Installer
- Meta manager
- Mi Cloud
- Mi Credit
- Mi Drop
- Mi Mover
- Mi Pay
- Mi Share
- Mi Recycle
- MiConnectService
- MiPlayClient
- Mi Wallpaper Carousel
- MiuiDaemon
- Music
- NextPay
- Notes
- Quick Apps
- Services & Feedback
- Xiaomi Sim Activate Service
- Xiaomi Service Framework

#### Critical System Apps
> ⚠️ Warning: Never remove these system apps:
- **VsimCore** - Required for data usage 
- **VsimCore** (Otherwise you won't get Data Usage on Control Centre tile)
- **MiVideo** [Otherwise you can't view/edit SlowMo Vids taken from Stock Camera]
- **Battery & Performance**
- **Power Detector**
- **Security App [Happy Bootloop]**
- **Mi Wallpaper**
- **Joyose** [something related to GPU and game booster, might cause bootloop]
