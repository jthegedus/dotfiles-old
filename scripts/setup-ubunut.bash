sudo apt install git curl tar apt-transport-https -y
sudo apt install gnome-tweaks -y
sudo snap install gitkraken
sudo snap install code --classic
sudo snap install discord signal-desktop
sudo snap install slack --classic
sudo snap install plexmediaserver

tar -xvf ~/Downloads/firefox-\*.tar.bz2 --directory ~/Downloads
sudo mv ~/Downloads/firefox /opt/firefox_dev

create ~/.local/share/applications/firefox_dev.desktop with the following contents

```
[Desktop Entry]
Name=Firefox Developer
GenericName=Firefox Developer Edition
Exec=/opt/firefox_dev/firefox %u --class=FirefoxDev
StartupWMClass=FirefoxDev
Terminal=false
Icon=/opt/firefox_dev/browser/chrome/icons/default/default128.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Developer Edition Web Browser
```

chmod +x ~/.local/share/applications/firefox_dev.desktop

# Fix Gitkraken snap launcher icon

sudo echo "\nIcon=/snap/gitkraken/current/usr/share/gitkraken/gitkraken.png" >> /var/lib/snapd/desktop/applications/gitkraken_gitkraken.desktop
