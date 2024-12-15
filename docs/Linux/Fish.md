---
label: Fish Shell
icon: command-palette
order: 90
---

### Fish Shell Setup
- Change to fish temporarily by running command: `fish`
- Then install fisher and tide by running:

```bash
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher && fisher install ilancosman/tide
```

- Change the default shell to `fish` by:

```bash
sudo chsh $USER -s /bin/fish 
```
- Logout and login again to see tha change.
  
#### Fish aliasis
| Alias          | Command                                                        |
|----------------|----------------------------------------------------------------|
| ..             | cd ..                                                          |
| ...            | cd ../..                                                       |
| cl             | clear                                                          |
| src            | source ~/.config/fish/config.fish                              |
| update-mirrors | sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syu          |
| ls             | eza -a --color=always --group-directories-first                |

