First of all install fish using :
```sh
sudo pacman -S fish
```
Then install fisher by :
```sh
sudo curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```
Now install Tide for fisher using :
```sh
fisher install ilancosman/tide
```
For changing the deafult shell to fish use :
- First enter :
```sh
echo /usr/local/bin/fish | sudo tee -a /etc/shells  
```
- Then enter following and select fish as deafult shell :
```sh
chsh
```
Now logout and login again and your deafult shell will bw fish.