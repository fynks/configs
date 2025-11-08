set fish_greeting ''
set -gx EDITOR subl

### ALIASES ###
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias cl='clear'

# Safer `chmod +x` (avoids accidental overwrite)
alias chx='chmod u+x'

# Fish
alias src='source ~/.config/fish/config.fish'

# Pacman (Arch)
alias update-mirrors='sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syu'

# Changing "ls" to "eza"
alias ls='eza -al --color=always --icons --group-directories-first' # my preferred listing
alias ll='eza -al --color=always --icons --group-directories-first --header --git' # detailed listing


# Bat as cat replacement
if command -v bat &>/dev/null
    alias cat='bat --paging=never --style=plain'
end

### SETUP ZOXIDE ###
zoxide init fish | source