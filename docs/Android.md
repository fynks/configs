---
label: Android
icon: device-mobile
order: 50
---
### Apps
#### Play Store
- [1DM+](https://play.google.com/store/apps/details?id=idm.internet.download.manager.plus) 
- [AdGuard Mail](https://play.google.com/store/apps/details?id=com.adguard.email) 
- [AdGuard VPN](https://play.google.com/store/apps/details?id=com.adguard.vpn) 
- [Bitwarden](https://play.google.com/store/apps/details?id=com.x8bit.bitwarden) 
- [Brave](https://play.google.com/store/apps/details?id=com.brave.browser) 
- [Brave - Beta](https://play.google.com/store/apps/details?id=com.brave.browser_beta) 
- [Brave - Nightly](https://play.google.com/store/apps/details?id=com.brave.browser_nightly) 
- [Daraz](https://play.google.com/store/apps/details?id=com.daraz.android) 
- [easypaisa](https://play.google.com/store/apps/details?id=pk.com.telenor.phoenix) 
- [Ente Auth](https://play.google.com/store/apps/details?id=io.ente.auth) 
- [Facebook](https://play.google.com/store/apps/details?id=com.facebook.katana) 
- [Inoreader](https://play.google.com/store/apps/details?id=com.innologica.inoreader) 
- [JazzCash](https://play.google.com/store/apps/details?id=com.techlogix.mobilinkcustomer) 
- [Messenger](https://play.google.com/store/apps/details?id=com.facebook.orca) 
- [Microsoft SwiftKey Beta Keyboard](https://play.google.com/store/apps/details?id=com.touchtype.swiftkey.beta) 
- [MJ PDF](https://play.google.com/store/apps/details?id=com.gitlab.mudlej.MjPdfReader) 
- [NayaPay](https://play.google.com/store/apps/details?id=com.nayapay.app) 
- [ONLYOFFICE Documents](https://play.google.com/store/apps/details?id=com.onlyoffice.documents) 
- [Poweramp](https://play.google.com/store/apps/details?id=com.maxmpz.audioplayer) 
- [Poweramp Full Version Unlocker](https://play.google.com/store/apps/details?id=com.maxmpz.audioplayer.unlock) 
- [Proton Mail](https://play.google.com/store/apps/details?id=ch.protonmail.android) 
- [ROX](https://play.google.com/store/apps/details?id=com.jazz.rox) 
- [Snapchat](https://play.google.com/store/apps/details?id=com.snapchat.android) 
- [Tasks](https://play.google.com/store/apps/details?id=com.google.android.apps.tasks) 
- [Tuta](https://play.google.com/store/apps/details?id=de.tutao.tutanota) 
- [VLC](https://play.google.com/store/apps/details?id=org.videolan.vlc) 

#### Droid-ify
- TBD

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
### Find all media files
```sh
find . -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.wav" \) > media_files.txt

### Debloating HyperOS
#### Automatic tool:
```bash
git clone https://github.com/fynks/android-debloater.git
cd android-debloater
chmod +x debloat.sh
./debloat.sh
```

#### Manual Debloating
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
