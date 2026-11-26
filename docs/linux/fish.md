---
layout: doc
title: Fish Shell Configuration
description: Complete guide to setting up and configuring Fish shell with modern tools and productivity enhancements
---

# Fish Shell Configuration Guide

Fish (Friendly Interactive Shell) is a modern, user-friendly command line shell with powerful features like syntax highlighting, autosuggestions, and smart tab completions.

## 📦 Installation & Setup

### Installing Fish Shell

```bash
sudo pacman -S fish
```

### Initial Setup Process

1. **Test Fish temporarily** (recommended first step):
   ```bash
   fish
   ```

2. **Install Fisher (Plugin Manager)**:
   ```bash
   curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
   ```

3. **Install Tide Prompt** (Modern, fast prompt):
   ```bash
   fisher install ilancosman/tide
   ```

4. **Set Fish as default shell**:
   ```bash
   sudo chsh $USER -s /usr/bin/fish
   ```
   
   ::: warning Important
   Logout and login again for the change to take effect. You can verify with `echo $SHELL`.
   :::

## ⚙️ Configuration

### Essential Plugins

Install these useful plugins with Fisher:

```bash
# Better file listing
fisher install PatrickF1/fzf.fish

# Enhanced directory navigation
fisher install jethrokuan/z

# Node.js version manager
fisher install jorgebucaran/nvm.fish

# Git integration
fisher install jhillyerd/plugin-git
```

### Config File Location

Fish configuration is stored in:
```
~/.config/fish/config.fish
```

## 🔗 Useful Aliases

Add these to your `~/.config/fish/config.fish`:

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `cl` | `clear` | Clear terminal |
| `src` | `source ~/.config/fish/config.fish` | Reload Fish config |
| `ll` | `eza -la --color=always --group-directories-first` | Detailed file listing |
| `ls` | `eza -a --color=always --group-directories-first` | Enhanced file listing |
| `update-mirrors` | `sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syu` | Update Manjaro mirrors |
| `grep` | `grep --color=auto` | Colorized grep |

### Adding Aliases

To add a persistent alias, edit your config file:

```bash
# Open config file
nano ~/.config/fish/config.fish

# Add alias (example)
alias ll "eza -la --color=always --group-directories-first"
```

## 🎨 Customization

### Tide Prompt Configuration

Configure your prompt with:
```bash
tide configure
```

This will guide you through:
- Prompt style selection
- Color scheme options
- Information display preferences

## 💡 Pro Tips

### Key Features to Learn

1. **Autosuggestions**: Fish suggests commands as you type (based on history)
   - Press `→` or `Tab` to accept suggestion

2. **Syntax Highlighting**: Invalid commands are highlighted in red
   - Valid commands appear in blue/white
   - Existing files/paths are underlined

3. **Smart Tab Completion**: Context-aware completions
   - Works with command options, file paths, git branches, etc.

4. **History Search**: Type partial command and press `↑`
   - Searches through command history

### Useful Key Bindings

| Key Combination | Action |
|----------------|--------|
| `Ctrl + R` | Search command history |
| `Alt + ←/→` | Move by word |
| `Alt + ↑/↓` | Move by line in multiline commands |
| `Ctrl + A/E` | Move to beginning/end of line |
| `Ctrl + K` | Delete from cursor to end of line |

## 🔧 Troubleshooting

### Common Issues

**Fish not starting after setting as default:**
```bash
# Check if fish path is correct
which fish
# Update shell path if needed
sudo chsh $USER -s $(which fish)
```


## 📚 Further Reading

- [Official Fish Documentation](https://fishshell.com/docs/current/)
- [Fisher Plugin Directory](https://github.com/jorgebucaran/fisher)
- [Tide Prompt Documentation](https://github.com/IlanCosman/tide)
- [Fish Community Plugins](https://github.com/fish-shell/fish-shell/wiki/Plugins)

