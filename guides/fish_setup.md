#### First of all install fish using :

```sh
sudo pacman -S fish
```

##### Then install fisher by :

```sh
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```

##### Now install Tide for fisher using :

```sh
fisher install ilancosman/tide
```

#### For changing the deafult shell to fish use :

1. First enter :
   
   ```sh
   echo /usr/local/bin/fish | sudo tee -a /etc/shells  
   ```

2. Then enter following and select fish as deafult shell :
   
   ```sh
   chsh
   ```

3. Now logout and login again and your deafult shell will be fish
   For removing the welcome to fish shell messsage type :
   
   ```sh
   touch ~/.config/fish/functions/fish_greeting.fish   
   ```

#### For setting up the fish in graphical mode enter :

```sh
fish_config
```

- In abbrevations tab enter following :

| Abbrevation  | Command                        |
| ------------ | ------------------------------ |
| cl           | clear                          |
| nat          | sudo nautilus                  |
| pfetch       | ./fm6000                       |
| update       | sudo pacman -Syyuu && yay -Syu |
| clean-orphan | sudo pacman -Rs (pacman -Qqdt) |
