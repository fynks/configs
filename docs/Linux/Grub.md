---
label: Grub
icon: terminal
--- 

### Grub Showing no menu
1. From terminal:
```sh
sudo nano  /etc/default/grub
```
2. Change `GRUB_TIMEOUT_STYLE=hidden` to 
```sh
GRUB_TIMEOUT_STYLE=menu
```

### Fix `grub` after windows re-install
- Boot into Manjaro live environment
- Open terminal
```sh
sudo manjaro-chroot -a
```
```sh
grub-install /dev/sda
```
(it's sda for me; make sure you choose the right drive!)
```sh
grub-install --recheck /dev/sda
```
```sh
update-grub
```
```sh
exit
```
```sh
reboot
```
  

