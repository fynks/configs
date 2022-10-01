## Menu :
- [OS and Setup](#os-and-setup)
  - [Firefox](#firefox-setup)
  - [VS Code](#visual-studio-code)
- [Browsers](#browsers)
  - [Extension configs](#extension-configs-) 
  - [other configs](#other-configs)
- [Tools and Links](#tools-and-links-)


  ---

## OS and Setup 
- [Apps installer Script](https://raw.githubusercontent.com/fynks/configs/main/setup/setup.sh)
- [Chaotic AUR](https://github.com/chaotic-aur)
- [Shortcuts](https://raw.githubusercontent.com/fynks/configs/main/setup/custom_shortcuts)
- [Xampp](https://github.com/fynks/configs/blob/main/setup/xampp-htdocs.zip)

> ### Firefox Setup

1. After installing firefox,get latest _better-fox User.js_ from :
[Better-Fox](https://github.com/yokoffing/Better-Fox/blob/master/user.js)

2. Fix firefox proton design by adding: 
[Firefox-UI-Fix](https://github.com/black7375/Firefox-UI-Fix)


> ### Visual Studio Code

After grabbing the package from your distribution's package manager,you have to do following trouble shooting in order to setup sync and permanently store credentials on linux.

1. Run the ```vs_code_config.sh``` [Script](https://raw.githubusercontent.com/fynks/configs/main/setup/vs_code_config.sh)
2. Launch seahorse, unlock the default password keyring or create a new one, and keep it unlocked.
3. Logout the device and login.
4. Now login into github again in vs code.

> Refrence : https://code.visualstudio.com/docs/editor/settings-sync#_linux


---

## Browsers

|**Extensions**                |**Firefox**                                                                      |**Chrome**                                                                                                 |
|:------------------------------|:---------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------|
|Ublock Origin                 |[Get](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/)             |[Get](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)            |
|Clearurls                     |[Get](https://addons.mozilla.org/en-US/firefox/addon/clearurls/)                 |[Get](https://chrome.google.com/webstore/detail/clearurls/lckanjgmijmafbedllaakclkaicjfmnk/)               |
|Redirector                    |[Get](https://addons.mozilla.org/en-US/firefox/addon/redirector/)                |[Get](https://chrome.google.com/webstore/detail/redirector/ocgpenflpmgnfapjedencafcfakcekcd)               |
|Cookie Autodelete             |[Get](https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/)         |[Get](https://chrome.google.com/webstore/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh/)       |
|Firefox Containers            |[Get](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)  | --- |
|Firefox Containers  Helper|[Get](https://addons.mozilla.org/en-US/firefox/addon/containers-helper/)  |  --- |           
|Bitwarden                     |[Get](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/)|[Get](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb)|
|Xdm                           |[Get](https://addons.mozilla.org/en-US/firefox/addon/xdm-integration-module/)       |[Get](https://chrome.google.com/webstore/detail/xtreme-download-manager/dkckaoghoiffdbomfbbodbbgmhjblecj)  |
|Skip Redirect                 |[Get](https://addons.mozilla.org/en-US/firefox/addon/skip-redirect/)             |[Get](https://chrome.google.com/webstore/detail/skip-redirect/jaoafjdoijdconemdmodhbfpianehlon)            |
|LibRedirect                 |[Get](https://addons.mozilla.org/firefox/addon/libredirect/)             |[Get](https://github.com/libredirect/libredirect/blob/master/chromium.md)            |
|Dark Background And Light Text|[Get](https://addons.mozilla.org/en-US/firefox/addon/dark-background-light-text/)|---                                                                                                        |
|Dark Reader                   |[Get](https://addons.mozilla.org/en-US/firefox/addon/darkreader/)                |[Get](https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh)              |
|Improve Youtube               |[Get](https://addons.mozilla.org/en-US/firefox/addon/youtube-addon/)             |[Get](https://chrome.google.com/webstore/detail/improve-youtube-video-you/bnomihfieiccainjcjblhegjgglakjdd)|
|Sponsor Block               |[Get](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/)             |[Get](https://chrome.google.com/webstore/detail/mnjggcdmjocbbbhaepdhchncahnbgone)|
|Anonaddy                      |[Get](https://addons.mozilla.org/en-GB/firefox/addon/anonaddy/)                  |[Get](https://chrome.google.com/webstore/detail/anonaddy-anonymous-email/iadbdpnoknmbdeolbapdackdcogdmjpe) |
|Tampermonkey                  |[Get](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/)              |[Get](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)             |

### Extension configs :
- [Redirector](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/Redirector.json)
- [UBlock Origin](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/u_block_origin_configs.txt)
- Firefox Container Helpers (https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/containers.json)
- [Sponsor Block](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/SponsorBlockConfig.json)
- [Improve Tube](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/improvedtube.txt)
- [LibRedirect](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/libredirect-settings.json)
  
### other configs
- [Bookmarklets](https://github.com/fynks/configs/blob/main/browsers/bookmarklets.md)
- [Userscripts](https://github.com/fynks/userscripts)
- [Firefox Cookie Clearance Exception List](https://raw.githubusercontent.com/fynks/configs/main/browsers/firefox_cookie_clearance_exception_list.md)
- [Teddit Prefs](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/teddit_prefs.json)
- [Bookmarks](https://github.com/fynks/siqo/tree/main/dist/dash)
- [Feeds](https://github.com/fynks/siqo/tree/main/dist/dash)

---


### Tools and links :
- [XDM](https://github.com/subhra74/xdm)
- [Links](https://github.com/fynks/things/blob/main/links.md)
- [Github](https://github.com/fynks/configs)
