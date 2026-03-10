#!/bin/bash
#Подготовка к установке 1С на клиентском ПК
sudo apt update
sudo apt dist-upgrade
sudo apt dist-upgrade --fix-broken

#Отключение модуля vhci-hcd
sudo lsmod
sudo modprobe -r vhci-hcd
sudo cp /etc/modules-load.d/usb-over-ip-load.conf /etc/modules-load.d/usb-over-ip-load.conf_bak
sudo nano /etc/modules-load.d/usb-over-ip-load.conf

#Добавить locale CP1251 для работы отчетности.
sudo apt-get install locales && sudo localedef -c -i ru_RU -f CP1251 ru_RU.CP1251
apt-get install locales
localedef -c -i ru_RU -f CP1251 ru_RU.CP1251
locale -a | grep ru_RU.cp1251

#Установка зависимостей
sudo apt install gstreamer1.0-plugins-bad unixodbc imagemagick libgsf-1-114 whiptail dialog cabextract

#Установка шрифтов Microsoft
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb
sudo apt install cabextract
sudo apt install --fix-broken
sudo dpkg -i ttf-mscorefonts-installer_3.8.1_all.deb
fc-cache -f -v
