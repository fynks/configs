---
label: Configs
icon: gear
---

## Menu :
- [Linux](#linux)
  - [Arch Linux Setup](#arch-linux-setup)
  - [Fish Shell Setup](#fish-shell-setup)
  - [Visual Studio Code](#visual-studio-code)
- [Windows](#windows)
  - [Microsoft-Activation-Scripts](#microsoft-activation-scripts)
  - [Winutil by ChrisTitusTech](#winutil-by-christitustech)
  - [Applications](#applications)
- [Browsers](#browsers)
  - [Extensions](#extensions)
  - [Browser Configs](#browser-configs)
  - [Extension configs](#extension-configs)
  - [Other configs](#other-configs)

## Linux
### Arch Linux Setup
``` sh
git clone https://github.com/fynks/configs.git && cd configs/setup/scripts/ && sudo chmod +x ./setup.sh && sudo ./setup.sh
```
- [Chaotic AUR](https://github.com/chaotic-aur)
- [HBlock](https://raw.githubusercontent.com/fynks/configs/main/setup/configs/hblock_sources.list)

### Fish Shell Setup
   - Change to fish temporarily by running command: `fish`
   - Then install fisher and tide by running:
 ``` bash
 sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher && fisher install ilancosman/tide
 ```
   - Remove the welcome msg from fish shell by:
 ``` bash
 mkdir -p ~/.config/fish/functions/
echo 'function fish_greeting; end' > ~/.config/fish/functions/fish_greeting.fish
```
  - Change the default shell to `fish` by:
``` bash
sudo sh -c 'echo /usr/bin/fish >> /etc/shells'
chsh -s /usr/bin/fish 
```
  - Logout and login again to see tha change.
  - For abbreviation guidelines visit [here](https://fishshell.com/docs/current/cmds/abbr.html#examples)
   

### Visual Studio Code
1. After successfull run of `post_setup.sh` script:
2. Launch seahorse, unlock the default password keyring or create a new one, and keep it unlocked.
3. Logout the device and login.
4. Now login into github again in vs code.

> [Refrence](https://code.visualstudio.com/docs/editor/settings-sync#_linux)


---
## Windows
### Microsoft-Activation-Scripts 
``` pwsh
irm https://massgrave.dev/get | iex
```
- [Github for MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) 

### Winutil by ChrisTitusTech
``` pwsh
iwr -useb https://christitus.com/win | iex
```

- [Github for Winutil](https://github.com/ChrisTitusTech/winutil)

### Applications
|**Programs**                |**Link**                                                                      |
|:------------------------------|:---------------------------------------------------------------------------------|
|VLC                |[Download](https://www.videolan.org/vlc/download-windows.html)             |
|Firefox                |[Download](https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US)             |
|Chrome                |[Download](https://www.google.com/intl/en/chrome/?standalone=1)             |
|Peazip                |[Download](https://github.com/peazip/PeaZip/releases/latest)             |
|Image Glass                |[Download](https://github.com/d2phap/ImageGlass/releases)             |
|Sublime Text Editor                |[Download](https://www.sublimetext.com/download_thanks?target=win-x64)             |
|Office                |[Visit](https://massgrave.dev/genuine-installation-media.html)             |

---
## Browsers

### Firefox Setup

1. After installing firefox, get latest _better-fox User.js_ from :
[Better-Fox](https://github.com/yokoffing/Better-Fox/blob/master/user.js)

2. Fix firefox proton design by adding: 
[Firefox-UI-Fix](https://github.com/black7375/Firefox-UI-Fix/releases/latest)
3. Google search engine for firefox from [Mycroft](https://mycroftproject.com/install.html?id=14909&basename=google&icontype=ico&name=Google)

### Extensions

|**Extensions**                |**Firefox**                                                                      |**Chrome**                                                                                                 |
|:------------------------------|:---------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------|
|Ublock Origin                 |[Get](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/)             |[Get](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)            |
|Bitwarden                     |[Get](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/)|[Get](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb)|
|Addy.io                      |[Get](https://addons.mozilla.org/en-US/firefox/addon/addy_io/)                  |[Get](https://chrome.google.com/webstore/detail/addyio-anonymous-email-fo/iadbdpnoknmbdeolbapdackdcogdmjpe) |
|Tampermonkey                  |[Get](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/)              |[Get](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)             |
|LibRedirect                 |[Get](https://addons.mozilla.org/firefox/addon/libredirect/)             |[Get](https://github.com/libredirect/libredirect/blob/master/chromium.md)            |
|Firefox Containers            |[Get](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)  | --- |        
|Skip Redirect                 |[Get](https://addons.mozilla.org/en-US/firefox/addon/skip-redirect/)             |[Get](https://chrome.google.com/webstore/detail/skip-redirect/jaoafjdoijdconemdmodhbfpianehlon)            |
|Refined Github                |[Get](https://addons.mozilla.org/en-US/firefox/addon/refined-github-/)             |[Get](https://chrome.google.com/webstore/detail/refined-github/hlepfoohegkhhmjieoechaddaejaokhf)            |
|Xdm                           |[Get](https://addons.mozilla.org/en-US/firefox/addon/xdm-browser-monitor-v8/)       |[Get](https://subhra74.github.io/xdm/redirect.html?target=chrome&version=8.0)  |
|Improve Youtube               |[Get](https://addons.mozilla.org/en-US/firefox/addon/youtube-addon/)             |[Get](https://chrome.google.com/webstore/detail/improve-youtube-video-you/bnomihfieiccainjcjblhegjgglakjdd)|
|Sponsor Block               |[Get](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/)             |[Get](https://chrome.google.com/webstore/detail/mnjggcdmjocbbbhaepdhchncahnbgone)|
|Redirector                    |[Get](https://addons.mozilla.org/en-US/firefox/addon/redirector/)                |[Get](https://chrome.google.com/webstore/detail/redirector/ocgpenflpmgnfapjedencafcfakcekcd)               |

### Browser Configs
- [LibreWolf Overrides](https://raw.githubusercontent.com/fynks/configs/main/setup/configs/librewolf.overrides.cfg)
- [Cookie Clearance Exception List](https://raw.githubusercontent.com/fynks/configs/main/browsers/cookie_exception_list.md)


### Extension configs
- [LibRedirect](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/libredirect-settings.json)
- [UBlock Origin](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/u_block_origin_configs.txt)
- [No-Skip URL List](https://raw.githubusercontent.com/fynks/configs/main/browsers/extensions/no_skip_url_list.txt)
  
### Other configs
- [Userscripts](https://github.com/fynks/userscripts)
- [Bookmarklets](https://github.com/fynks/configs/blob/main/browsers/bookmarklets.md)
---
### Links:
- [Github](https://github.com/fynks/configs)
