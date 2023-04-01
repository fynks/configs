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

# Check if user is root
if test $EUID -ne 0
    echo -e "\n####################################\n######### This script must be run as root #########\n####################################\n"
    exit 1
end

# Installs and configures fisher and tide
echo -e "\n############################################\n######### Installing fisher and tide #########\n############################################\n"
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher && fisher install ilancosman/tide

# Remove welcome to fish annoying message
echo -e "\n############################################\n#### Removing fish welcome message ####\n############################################\n"
mkdir -p ~/.config/fish/functions/
echo 'function fish_greeting; end' > ~/.config/fish/functions/fish_greeting.fish

# Waiting for 1 second
sleep 1

# changing the default shell to fish
echo -e "\n############################################\n######### chaning shell #########\n############################################\n"
echo "please enter fish in selection"
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh

# Explaining the shell change
echo -e "\n############################################\n######### Shell will be changed automatically on next login #########\n############################################\n"

# Invokes the post_setup.sh script for various tweaks and fixes
echo -e "\n############################################\n######### Initiating Post config script #########\n############################################\n"
echo "Initiation successful"
sudo chmod +x "./post_setup.sh"
"./post_setup.sh"