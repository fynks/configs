#!/bin/bash

echo ""
echo ""
echo "Updating mirrors with fastest mirrors"
sudo pacman-mirrors --fasttrack
echo ""
echo "Syncing databases"
sudo pacman -Syyuu
echo ""
echo "Installing yay..."
sudo pacman -S yay
echo ""
echo "Installing ALACRITTY..."
sudo pacman -S alacritty
echo ""
echo "Installing CMAKE ..."
sudo pacman -S cmake
echo ""
echo "Installing Brave-DEV-BIN ..."
yay -S brave-dev-bin
echo ""
echo "Installing Sublime ..."
yay -S sublime-text-3
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
echo "Installing Thunderbird ..."
sudo pacman -S thunderbird
echo ""
echo "Installing Caffeine-ng..."
sudo pacman -S caffeine-ng
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
echo "Installing GOOGLE-CHROME ..."
yay -S google-chrome
echo ""
echo "Installing Telegram..."
sudo pacman -S telegram-desktop
echo ""
echo "Installing KODI ..."
sudo pacman -S kodi
echo ""
echo "Installing Simple Screen Recorder ..."
sudo pacman -S simplescreenrecorder
echo ""
echo "Installing Stretchly ..."
yay -S stretchly
echo ""
echo "------------------------------------------------------------"
echo ""
echo "Installing Fish"
pacman -S fish
echo ""
echo "Installing fisher"
ccurl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
echo""
echo"Now you can install IlanCosman/tide by going here https://github.com/IlanCosman/tide"
echo ""
echo "------------------------------------------------------------"
echo ""
echo "Installing hblock"

curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.0/hblock' \
  && echo 'b9ed6de52455fbde882879ef50470c1538bc5ac8d1479ef130442770b159dbe3  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown 0:0 /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock

echo""
echo"run hblock for updating hosts,for more visist : https://github.com/hectorm/hblock "




















