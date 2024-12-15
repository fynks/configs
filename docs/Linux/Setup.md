---
label: Setup
icon: terminal
---

### Arch Linux Setup

```sh
git clone https://github.com/fynks/configs.git && cd configs/setup/ && sudo chmod +x ./setup.sh && sudo ./setup.sh
```

### Manjaro Mirrors update
```bash
sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syu 
```

### [Chaotic AUR](https://github.com/chaotic-aur)
```bash
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
```
```bash
sudo pacman-key --lsign-key 3056513887B78AEB
```
```bash
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```
- Append (adding to the end of the file) to `/etc/pacman.conf`:
```
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```

### KDE Setup

```bash
konsave -i manjaro-kde.knsv
```

### [HBlock](https://raw.githubusercontent.com/fynks/configs/main/setup/configs/hblock_sources.list)


