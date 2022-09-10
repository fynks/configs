#!/usr/bin/env fish

# Instals and configures fisher and tide
echo -e "\n############################################\n######### Intalling fisher and tide #########\n############################################\n"
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher && fisher install ilancosman/tide

# fish abbreviation setup
echo -e "\n############################################\n#### opening the fish abbreviatons windows ####\n############################################\n"
echo "Close the browser window and press ENTER to continue"
fish_config

# Remove welcome to fish annoying message
echo -e "\n############################################\n#### Removing fish welcome message ####\n############################################\n"
touch ~/.config/fish/functions/fish_greeting.fish

# changing the default shell to fish
echo -e "\n############################################\n######### chaning shell #########\n############################################\n"
echo "please enter fish in selection"
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh

# logging out for completing the process
echo -e "\n############################################\n######### Logging out #########\n############################################\n"
qdbus org.kde.ksmserver /KSMServer logout 1 0 3

echo -e "\n############################################\n######### DONE #########\n############################################\n"
exit 