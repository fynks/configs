# Linux Setup Guide
* [Fish Shell](https://github.com/fynks/configs/blob/main/guides/linux_setup.md#fish-shell)
* [FIrefox Setup](https://github.com/fynks/configs/blob/main/guides/linux_setup.md#firefox-setup)
* [Xampp Setup](https://github.com/fynks/configs/blob/main/guides/linux_setup.md#xampp-auto-start)
  
---
## Fish Shell
1. First of all install fish using :

```sh
sudo pacman -S fish
```

2. Then install fisher by :

```sh
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```

3. Now install Tide for fisher using :

```sh
fisher install ilancosman/tide
```

4. For changing the deafult shell to fish use :

5. First enter :
   
   ```sh
   echo /usr/local/bin/fish | sudo tee -a /etc/shells  
   ```

6. Then enter following and select fish as deafult shell :
   
   ```sh
   chsh
   ```

7. Now logout and login again and your deafult shell will be fish
   For removing the welcome to fish shell messsage type :
   
   ```sh
   touch ~/.config/fish/functions/fish_greeting.fish   
   ```

8. For setting up the fish in graphical mode enter :

```sh
fish_config
```

- In abbreviations tab enter following :

| Abbrevation  | Command                           |
| ------------ | --------------------------------- |
| cl           | clear                             |
| nat          | sudo nautilus                     |
| fm6000       | fm6000 -m 4 -l 20 -g 6            |
| update       | sudo pacman -Syyuu && yay -Syu    |
| clean-orphan | sudo pacman -Rs (pacman -Qqdt)    |
| apache       | sudo /opt/lampp/lampp startapache |
| xampp        | sudo /opt/lampp/lampp start       |

----
## Firefox Setup

1. After installing firefox,get latest _better-fox User.js_ from :
[Better-Fox](https://github.com/yokoffing/Better-Fox/blob/master/user.js)

2. Fix firefox proton design by adding: 
[Firefox-UI-Fix](https://github.com/black7375/Firefox-UI-Fix)

3.Now change the preferences as :
```sh
Search Engine : DuckDuckGo
Clear History on exit : true
Under History > Settings > Active logins+Cookies : Disable
```
4.Add following to show close button only will hovering a background tab
```css
  /*=== Only show close buttons on background tabs when hovering with the mouse ===*/
.tabbrowser-tab:not([visuallyselected]) .tab-close-button {
  visibility: collapse !important;
  opacity: 0;
}
.tabbrowser-tab:hover .tab-close-button {
  visibility: visible !important;
  opacity: 1;
}

/* Animate */
@media (prefers-reduced-motion: no-preference) {
  /* Fade out */
  .tabbrowser-tab:not([visuallyselected]) .tab-close-button {
    transition: opacity 0.1s var(--animation-easing-function) !important;
  }

  /* Fade in */
  .tabbrowser-tab:hover .tab-close-button {
    transition: opacity 0.25s var(--animation-easing-function) !important;
  }
}
```

#### Other User.js :

- [arkenfox](https://github.com/arkenfox/user.js)
- [pyllyukko](https://github.com/pyllyukko/user.js/)

----

## Xampp Auto Start
⚠️ This will increase the boot time with addition of upto 15 more seconds therefore try to use fish abbreviations using apache and xampp shortcuts.

1.First creat and open a service file by :

```sh
sudo nano /etc/systemd/system/xampp.service
```

2.Then add following contents to the file :

```sh
[Unit]
Description=XAMPP

[Service]
ExecStart=/opt/lampp/lampp start
ExecStop=/opt/lampp/lampp stop
Type=forking

[Install]
WantedBy=multi-user.target
```

3.Then enable the service by :

```sh
sudo systemctl enable xampp.service
```


