### EXPORT ###
set fish_greeting  

### ALIASES ###
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias cl='clear'
alias chx +x= 'chmod +x'
alias src='source ~/.config/fish/config.fish'
alias update-mirrors='sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syu'

# Changing "ls" to "eza"
alias ls='eza -a --color=always --group-directories-first' # my preferred listing
alias ll='eza -al --color=always --group-directories-first' # detailed listing

### SETUP ZOXIDE ###
zoxide init fish | source
