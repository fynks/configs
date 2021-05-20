#### ⚠️ This will increase the boot time with addition of upto 15 more seconds therefore try to use fish abbreviations using apache and xampp shortcuts.

First creat and open a service file by :
```sh
sudo nano /etc/systemd/system/xampp.service
```
Then add following contents to the file :
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
Then enable the service by :
```sh
sudo systemctl enable xampp.service
```

