#!/bin/bash

echo ""
echo ""
echo "Updating mirrors with fastest mirrors"
sudo pacman-mirrors --fasttrack 20
echo ""
echo "Syncing databases"
sudo pacman -Syyuu
echo ""
echo "Installing base-devel"
sudo pacman -S base-devel
echo ""
echo "Installing CMAKE ..."
sudo pacman -S cmake
echo ""
echo "Installing yay..."
sudo pacman -S yay
echo ""
echo "Installing ALACRITTY ..."
sudo pacman -S alacritty
echo ""
echo "Installing Fish Shell ..."
sudo pacman -S fish
echo ""
echo "Installing Firefox ..."
yay -S firefox-bin
echo ""
echo "Installing Librewolf..."
yay -S librewolf-bin
echo ""
echo "Installing Brave-Bin ..."
yay -S brave-bin
echo ""
echo "Installing Sublime ..."
yay -S sublime-text-4
echo ""
echo "Installing Qimgv (Image viewer) ..."
yay -S qimgv
echo ""
echo "Installing Nautilus ..."
sudo pacman -S nautilus
echo ""
echo "Installing VLC MEDIA PLAYER..."
sudo pacman -S vlc
echo ""
echo "Installing Evince..."
sudo pacman -S evince
echo ""
echo "Installing Bleachbit ..."
sudo pacman -S bleachbit
echo ""
echo "Installing NodeJS.."
sudo pacman -S nodejs
echo ""
echo "Installing visual-studio-code-bin..."
yay -S visual-studio-code-bin
echo ""
echo "Installing ZOOM ..."
yay -S zoom
echo ""
echo "Installing App Image Launcher..."
sudo pacman -S appimagelauncher
echo ""
echo "Installing Telegram..."
sudo pacman -S telegram-desktop
echo ""
echo "Installing Simple Screen Recorder ..."
sudo pacman -S simplescreenrecorder
echo ""
echo "Installing hblock"
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.2/hblock' \
  && echo '72eac6d67001c7b31541cf3121c15e833fc99355970e4a117be46005d8465f63  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown 0:0 /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock
hblock





















