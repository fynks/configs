---
label: Android
icon: device-mobile
---
### Flash a custom recovery
```sh
fastboot devices
```
```sh
fastboot flash recovery recovery.img
```
> :icon-stop: Never ever reboot into recovery using fastboot command.

### Finding .m4a songs from terminal
```sh
find . -type f -name "*.m4a" > m4a.txt
```

### Debloating HyperOS
> We can remove these apps without affecting system.
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

> :icon-stop: Never Uninstall These Apps :
- VsimCore (Otherwise you won't get Data Usage on Control Centre tile)
- MiVideo [Otherwise you can't view/edit SlowMo Vids taken from Stock Camera]
- Battery & Performance
- Power Detector
- Security App [Happy Bootloop]
- Mi Wallpaper
- Joyose [something related to GPU and game booster, might cause bootloop]
