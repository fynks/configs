## Menu :
- [Linux](#linux)
- [Windows](#windows)
- [Browsers](#browsers)
  - [Extension configs](#extension-configs-) 
  - [other configs](#other-configs)
- [Andriod](#android)
- [Links](#links)


  ---

## Linux
- [Chaotic AUR](https://github.com/chaotic-aur)
- [Setup Script](https://raw.githubusercontent.com/fynks/configs/main/setup/setup.sh)
- [Shortcuts](https://raw.githubusercontent.com/fynks/configs/main/setup/custom_shortcuts)
- [XDM](https://github.com/subhra74/xdm-experimental-binaries/tags)

> ### Visual Studio Code

After grabbing the package from your distribution's package manager,you have to do following trouble shooting in order to setup sync and permanently store credentials on linux.

1. After successfull run of ```post_setup.sh``` script:
2. Launch seahorse, unlock the default password keyring or create a new one, and keep it unlocked.
3. Logout the device and login.
4. Now login into github again in vs code.

> [Refrence](https://code.visualstudio.com/docs/editor/settings-sync#_linux)


---
## Windows
|**Programs**                |**Link**                                                                      |
|:------------------------------|:---------------------------------------------------------------------------------|
|VLC                |[Download](https://www.videolan.org/vlc/download-windows.html)             |
|Firefox                |[Download](https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US)             |
|Chrome                |[Download](https://www.google.com/intl/en/chrome/?standalone=1)             |
|Peazip                |[Download](https://github.com/peazip/PeaZip/releases/latest)             |
|Image Glass                |[Download](https://github.com/d2phap/ImageGlass/releases)             |
|Sublime Text Editor                |[Download](https://www.sublimetext.com/download_thanks?target=win-x64)             |
|Office                |[Visit](https://massgrave.dev/genuine-installation-media.html)             |
|Activation Script                |[Visit](https://github.com/massgravel/Microsoft-Activation-Scripts)             |

---
## Browsers

> ### Firefox Setup

1. After installing firefox,get latest _better-fox User.js_ from :
[Better-Fox](https://github.com/yokoffing/Better-Fox/blob/master/user.js)

1. Fix firefox proton design by adding: 
[Firefox-UI-Fix](https://github.com/black7375/Firefox-UI-Fix/releases/latest)

|**Extensions**                |**Firefox**                                                                      |**Chrome**                                                                                                 |
|:------------------------------|:---------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------|
|Ublock Origin                 |[Get](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/)             |[Get](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)            |
|Bitwarden                     |[Get](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/)|[Get](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb)|
|Anonaddy                      |[Get](https://addons.mozilla.org/en-GB/firefox/addon/anonaddy/)                  |[Get](https://chrome.google.com/webstore/detail/anonaddy-anonymous-email/iadbdpnoknmbdeolbapdackdcogdmjpe) |
|Tampermonkey                  |[Get](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/)              |[Get](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)             |
|LibRedirect                 |[Get](https://addons.mozilla.org/firefox/addon/libredirect/)             |[Get](https://github.com/libredirect/libredirect/blob/master/chromium.md)            |
|Firefox Containers            |[Get](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)  | --- |
|Containers  Helper|[Get](https://addons.mozilla.org/en-US/firefox/addon/containers-helper/)  |  --- |           
|Skip Redirect                 |[Get](https://addons.mozilla.org/en-US/firefox/addon/skip-redirect/)             |[Get](https://chrome.google.com/webstore/detail/skip-redirect/jaoafjdoijdconemdmodhbfpianehlon)            |
|NX Enhanced                           |[Get](https://addons.mozilla.org/addon/nx-enhanced)       |[Get](https://chrome.google.com/webstore/detail/nx-enhanced/ljimbekophocjbnphldoaidgkkaojcfo)  |
|Xdm                           |[Get](https://addons.mozilla.org/en-US/firefox/addon/xdm-browser-monitor-v8/)       |[Get](https://subhra74.github.io/xdm/redirect.html?target=chrome&version=8.0)  |
|Dark Background And Light Text|[Get](https://addons.mozilla.org/en-US/firefox/addon/dark-background-light-text/)|---                                                                                                        |
|Improve Youtube               |[Get](https://addons.mozilla.org/en-US/firefox/addon/youtube-addon/)             |[Get](https://chrome.google.com/webstore/detail/improve-youtube-video-you/bnomihfieiccainjcjblhegjgglakjdd)|
|Sponsor Block               |[Get](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/)             |[Get](https://chrome.google.com/webstore/detail/mnjggcdmjocbbbhaepdhchncahnbgone)|
|Redirector                    |[Get](https://addons.mozilla.org/en-US/firefox/addon/redirector/)                |[Get](https://chrome.google.com/webstore/detail/redirector/ocgpenflpmgnfapjedencafcfakcekcd)               |
|Cookie Autodelete             |[Get](https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/)         |[Get](https://chrome.google.com/webstore/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh/)       |
|Dark Reader                   |[Get](https://addons.mozilla.org/en-US/firefox/addon/darkreader/)                |[Get](https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh)              |

### Extension configs :
- [Redirector](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/Redirector.json)
- [LibRedirect](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/libredirect-settings.json)
- [UBlock Origin](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/u_block_origin_configs.txt)
- [Sponsor Block](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/SponsorBlockConfig.json)
- [Improve Tube](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/improvedtube.txt)
- [Firefox Container Helpers](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/containers.json)
  
### other configs
- [Next-DNS](https://raw.githubusercontent.com/fynks/configs/main/setup/nextdns_config.json)
- [Userscripts](https://github.com/fynks/userscripts)
- [Bookmarklets](https://github.com/fynks/configs/blob/main/browsers/bookmarklets.md)
- [Custom search engines](https://mycroftproject.com/)
- [Firefox Cookie Clearance Exception List](https://raw.githubusercontent.com/fynks/configs/main/browsers/firefox_cookie_clearance_exception_list.md)


---

## Android
- [Droid-ify](https://github.com/Iamlooker/Droid-ify/releases/latest)
-  [Bromite](https://github.com/uazo/bromite-buildtools/releases/latest)
- [Filtrite](https://github.com/fynks/filtrite)
- [Bromite Userscipts](https://github.com/xarantolus/bromite-userscripts/releases/latest)



---
### Links :
- [Links](https://github.com/fynks/things/blob/main/links.md)
- [Github](https://github.com/fynks/configs)
