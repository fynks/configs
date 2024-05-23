---
label: Configs
icon: gear
---

## Menu :

- [Linux](#linux)
  - [Arch Linux Setup](#arch-linux-setup)
  - [Fish Shell Setup](#fish-shell-setup)
  - [KDE Setup](#kde-setup)
- [Windows](#windows)
  - [Microsoft Activation Scripts](#microsoft-activation-scripts)
  - [Winutil by ChrisTitusTech](#winutil-by-christitustech)
  - [Applications](#applications)
- [Browsers](#browsers)
  - [Firefox Setup](#firefox-setup)
  - [Browser Configs](#browser-configs)
    - [Firefox Policies](#firefox-policies)
    - [LibreWolf Overrides](#librewolf-overrides)
  - [Cookie Exception List](#cookie-exception-list)
  - [Extensions](#extensions)
  - [Extension configs](#extension-configs)
  - [Other configs](#other-configs)
  - [Links](#links)

## Linux

### Arch Linux Setup

```sh
git clone https://github.com/fynks/configs.git && cd configs/setup/ && sudo chmod +x ./setup.sh && sudo ./setup.sh
```

- [Chaotic AUR](https://github.com/chaotic-aur)
- [HBlock](https://raw.githubusercontent.com/fynks/configs/main/setup/configs/hblock_sources.list)

### Fish Shell Setup

- Change to fish temporarily by running command: `fish`
- Then install fisher and tide by running:

```bash
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher && fisher install ilancosman/tide
```

- Remove the welcome msg from fish shell by:

```bash
mkdir -p ~/.config/fish/functions/
echo 'function fish_greeting; end' > ~/.config/fish/functions/fish_greeting.fish
```

- Change the default shell to `fish` by:

```bash
sudo sh -c 'echo /usr/bin/fish >> /etc/shells'
chsh -s /usr/bin/fish
```

- Logout and login again to see tha change.
- For abbreviation guidelines visit [here](https://fishshell.com/docs/current/cmds/abbr.html#examples)

### KDE Setup

```bash
konsave -i manjaro-kde.knsv
```

## Windows

### Microsoft Activation Scripts

```pwsh
irm https://get.activated.win | iex
```

- [Github for MAS](https://github.com/massgravel/Microsoft-Activation-Scripts)

### Winutil by ChrisTitusTech

```pwsh
iwr -useb https://christitus.com/win | iex
```

- [Github for Winutil](https://github.com/ChrisTitusTech/winutil)

### Applications

| **Programs**        | **Link**                                                                                 |
| :------------------ | :--------------------------------------------------------------------------------------- |
| VLC                 | [Download](https://www.videolan.org/vlc/download-windows.html)                           |
| Firefox             | [Download](https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US) |
| Chrome              | [Download](https://www.google.com/intl/en/chrome/?standalone=1)                          |
| Peazip              | [Download](https://github.com/peazip/PeaZip/releases/latest)                             |
| Image Glass         | [Download](https://github.com/d2phap/ImageGlass/releases)                                |
| IDM                 | [Download](https://www.internetdownloadmanager.com/download.html)                        |
| Sublime Text Editor | [Download](https://www.sublimetext.com/download_thanks?target=win-x64)                   |
| Office              | [Visit](https://massgrave.dev/genuine-installation-media.html)                           |

---

## Browsers

### Firefox Setup

1. [Better-Fox](https://github.com/yokoffing/Betterfox/blob/main/user.js)

2. [Firefox-UI-Fix](https://github.com/black7375/Firefox-UI-Fix/releases/latest)
3. Google search
   engine [Mycroft](https://mycroftproject.com/install.html?id=118251&basename=anti-google&icontype=ico&name=G)

### Browser Configs

#### [Firefox Policies](https://raw.githubusercontent.com/fynks/configs/main/setup/browsers/policies.json)

> Should be placed in following paths:

```bash
/etc/firefox/policies
```

```pwsh
C:\Program Files\Mozilla Firefox\distribution
```

#### [LibreWolf Overrides](https://raw.githubusercontent.com/fynks/configs/main/setup/browsers/librewolf.overrides.cfg)

> Should be placed in:

```bash
$HOME/.librewolf/librewolf.overrides.cfg
```

### Cookie Exception List

```uri
https://github.com
```

```uri
https://netlify.com
```

```uri
https://chat.openai.com
```

```uri
https://google.com
```

```uri
https://inoreader.com
```

### Extensions

| **Extensions**     | **Firefox**                                                                       | **Chrome**                                                                                                  |
| :----------------- | :-------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------- |
| Ublock Origin      | [Get](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/)              | [Get](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)             |
| Bitwarden          | [Get](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/) | [Get](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb) |
| Addy.io            | [Get](https://addons.mozilla.org/en-US/firefox/addon/addy_io/)                    | [Get](https://chrome.google.com/webstore/detail/addyio-anonymous-email-fo/iadbdpnoknmbdeolbapdackdcogdmjpe) |
| Tampermonkey       | [Get](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/)               | [Get](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)              |
| LibRedirect        | [Get](https://addons.mozilla.org/firefox/addon/libredirect/)                      | [Get](https://github.com/libredirect/libredirect/blob/master/chromium.md)                                   |
| Firefox Containers | [Get](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)   | ---                                                                                                         |
| ImproveTube     | [Get](https://addons.mozilla.org/en-US/firefox/addon/youtube-addon/)               | [Get](https://chromewebstore.google.com/detail/improve-youtube-%F0%9F%8E%A7-for-yo/bnomihfieiccainjcjblhegjgglakjdd)                           |
| Sponsor Block      | [Get](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/)               | [Get](https://chrome.google.com/webstore/detail/mnjggcdmjocbbbhaepdhchncahnbgone)                           |

### Extension configs

- [UBlock Origin](https://raw.githubusercontent.com/fynks/configs/main/browsers/u_block_origin_configs.txt)
- [LibRedirect](https://raw.githubusercontent.com/fynks/configs/main/browsers/libredirect.json)
- [ImproveTube](https://raw.githubusercontent.com/fynks/configs/main/browsers/improvedtube.json)


### Other configs

- [Userscripts](https://github.com/fynks/userscripts)
- [Bookmarklets](https://github.com/fynks/configs/blob/main/browsers/bookmarklets.md)

---

### Links

- [Github](https://github.com/fynks/configs)
