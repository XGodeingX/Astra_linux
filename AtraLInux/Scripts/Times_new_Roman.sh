#!/bin/bash
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb
sudo apt install cabextract
sudo apt install --fix-broken
sudo dpkg -i ttf-mscorefonts-installer_3.8.1_all.deb
fc-cache -f -v
