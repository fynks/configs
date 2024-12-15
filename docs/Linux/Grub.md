---
label: Grub
icon: tools
order: 80
--- 

### Grub Showing no menu
When you freshly install grub it does not show any menu during boot instead it directly boot only showing a blank black screen.
1. From terminal:
```sh
sudo nano  /etc/default/grub
```
2. Change `GRUB_TIMEOUT_STYLE=hidden` to 
```sh
GRUB_TIMEOUT_STYLE=menu
```

### Fix grub after windows re-install
Reinstalling windows somwtimes nukes the grub,therefore you have to reinstall it by:
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
  

