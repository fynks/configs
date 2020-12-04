#!/bin/bash


echo ""
echo " 
         /\   | |    |_   _/ ____| |    |  ____| |    / __ \ 
        /  \  | |      | || |  __| |    | |__  | |   | |  | |
       / /\ \ | |      | || | |_ | |    |  __| | |   | |  | |
      / ____ \| |____ _| || |__| | |____| |____| |___| |__| |
     /_/    \_\______|_____\_____|______|______|______\____/ 
                                                                

                 Officail Apps installer script                 "

echo ""

[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

echo ""
echo "Installing VLC MEDIA PLAYER..."
pacman -S nautilus

echo ""
echo "Installing SImple Screen Recorder ..."
pacman -S simplescreenrecorder

echo ""
echo "Installing Telegram..."
pacman -S telegram-desktop

echo ""
echo "Installing ALACRITTY..."
pacman -S alacritty

echo ""
echo "Installing Evince..."
pacman -S evince

echo ""
echo "Installing VLC MEDIA PLAYER..."
pacman -S vlc

echo ""
echo "Installing NodeJS.."
pacman -S nodejs

echo ""
echo "Installing Stacer ..."
pacman -S stacer

echo ""
echo "Installing KODI ..."
pacman -S kodi

echo ""
echo "Installing GIMP..."
pacman -S gimp




