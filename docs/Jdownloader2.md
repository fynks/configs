---
label: JDownloader
icon: desktop-download
---
# JDownloader2 Guide
## Debloating JDownloder2
1. Once JDownloader is installed, open it and go to Settings -> Advanced Settings (the icon with a warning sign).
2. In the Filters Settings, search for the following values and disable them by clicking on the check-mark button:

```bash
premium alert
```

```bash
oboom
```

```bash
Special Deals
```

```bash
Donate
```

```bash
Banner
```

3. These values are responsible for showing ads and pop-ups for premium accounts and other offers. Disabling them will make JDownloader ad-free and less cluttered.

4. You can also optimize JDownloader by doing the following:
- Disable speed limits by going to Settings -> Speed Limit -> No Limit
- Minimize and resize the window when downloading to save screen space
- Disable window decoration by going to Settings -> User Interface -> Window Decoration -> None
- Disable speed meter graph by right-clicking on it or going to Advanced Settings and unchecking GraphicalUserInterfaceSettings.speedmeterenabled
- Set logging to off by going to Advanced Settings and unchecking Log.Loglevel
- Turn off your VPN if you don't need it, as it can affect your download speed
- Turn off addons that you don't use or need by going to Settings -> Addons and unchecking them 

> [Source](https://www.reddit.com/r/Piracy/comments/133ib8s/guide_how_to_install_and_debloat_jdownloader/)

## Installing Dracula theme (Easy dark mode)
1. If you are a git user, you can install the theme and keep up to date by cloning the repo:
```shell
git clone https://github.com/dracula/jdownloader2.git
```
2. In JDownloader2 go to Settings > Advanced Settings
3. Search for `GraphicalUserInterfaceSettings: Look And Feel Theme` and change the value from Default to `FLATLAF_DRACULA`
4. Get the `FlatDarculaLaf.json` file and place it in `JDownloader\cfg\laf\` (Create the folder structure if it doesn't exist).
5. Restart JDownloader2

> [Source](https://draculatheme.com/jdownloader2)


## Manual Dark Mode
1. First we go to the Settings tab, scroll down on the left side-bar and click on Advanced Settings, this is where we'll be working. 
2. On the search bar type "theme" (without the " "s), and change the value to BLACK_EYE. 
3. JD2 will prompt you to download and install the theme package, click Ok, and install.
If it's doesn't automatically, close and reopen JDownloader. 
4. When you open it again, JD will look all messed up, this is normal and we will fix it in the following steps:
- In the Advanced Settings search bar, type "color back".
- Change all the whites and light blues to dark grey or black.
- Do not change the red and yellow, only change the whites and light blues.
- You might want to make the first 3 values a bit lighter shade of dark grey for functionality. 
-  Go to the RGB tab and copy-paste the "222222" color code.
- Alternatively, you can change the "Value", "Darkness" or "Black" values in the HSV, HSL or CMYK tabs respectively to adjust how dark you want your dark mode.
- The "Color For Table Alternate Row Background" seems to bug out for some reason and not take the "222222" color code, to fix this, set it to some other color first, and then change it to dark grey or black. 
5. Back on Advanced Settings, search "color fore", and change all the blacks and whites to white.
- Again, do not change the red, and blues, only the whites and blacks.
- Some values are set to white by default, but I like to set them manually anyway to make sure they will display properly.
6. Finally search "color text", and change all the colors to white.
- Only the "Config Label Disabled Text Color" goes grey. 
7. Restart JDownloader and your dark theme should be all set up.
8. Every time JD updates, the color settings will be back to default, and it will look messed up, simply close and reopen JD again, and the colors should be back to normal.

> [Source](https://www.reddit.com/r/jdownloader/comments/q3xrgj/how_to_dark_mode_jdownloader_2/)

