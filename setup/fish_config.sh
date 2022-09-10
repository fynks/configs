#!/usr/bin/env fish
#-------------------------------------------------------------------------
#   ______ __     __ _   _  _  __  _____ 
# |  ____|\ \   / /| \ | || |/ / / ____|
# | |__    \ \_/ / |  \| || ' / | (___  
# |  __|    \   /  | . ` ||  <   \___ \ 
# | |        | |   | |\  || . \  ____) |
# |_|        |_|   |_| \_||_|\_\|_____/ 
#                                       
#  Fish Shell Setup and config file
#-------------------------------------------------------------------------

# Instals and configures fisher and tide
echo -e "\n############################################\n######### Intalling fisher and tide #########\n############################################\n"
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher && fisher install ilancosman/tide

# Remove welcome to fish annoying message
echo -e "\n############################################\n#### Removing fish welcome message ####\n############################################\n"
touch ~/.config/fish/functions/fish_greeting.fish

# Add abbreviations for fish shell
echo -e "\n############################################\n#### Adding Abbreviations ####\n############################################\n"
abbr -a cl "clear"
abbr -a sudon "sudo nemo"
abbr -a clean-orphan "sudo pacman -Rs (pacman -Qqdt)"
abbr -a hblock-disable "hblock -S none -D none"
abbr -a update-mirrors "sudo pacman-mirrors --fasttrack 10 && sudo pacman -Syyu"
abbr -a start-inputremapper "systemctl start input-remapper.service"

# changing the default shell to fish
echo -e "\n############################################\n######### chaning shell #########\n############################################\n"
echo "please enter fish in selection"
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh

# Wait for input
sleep 2

# logging out for completing the process
echo -e "\n############################################\n######### Logging out #########\n############################################\n"
qdbus org.kde.ksmserver /KSMServer logout 1 0 3

echo -e "\n############################################\n######### DONE #########\n############################################\n"
exit 