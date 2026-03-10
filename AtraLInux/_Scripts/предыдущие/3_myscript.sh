#!/bin/bash
echo -n "Имя пользователя для разрешения примонтировать флешки с сдромом (запускаем после инициализации)?: "
read profil_name
sudo usermod -aG floppy $profil_name
sudo usermod -aG cdrom $profil_name

sudo dpkg -i /home/admoi/Desktop/AstraLinux_Guide/Программы/*.deb
sudo apt --fix-broken install
sudo apt -y autoremove
sudo apt full-upgrade

sudo apt install -y seahorse yandex-browser-stable cifs-utils htop glmark2 fly-admin-samba libusb-0.1-4 icoutils libcupsimage2
sudo apt install -y wine winetricks libmspack0 cabextract zenity -fy
sudo apt install -y libpaper-utils printer-driver-cups-pdf system-config-printer cups-x2go ttf* fonts* -fy
systemctl disable sssd
astra-ptrace-lock disable

mkdir -p /mnt/base
mkdir -p /mnt/mail
mkdir -p /mnt/consplus
mkdir -p /mnt/consplusregion
mkdir -p /mnt/kodeks_client
chmod 777 /mnt/base
chmod 777 /mnt/mail
chmod 777 /mnt/consplus
chmod 777 /mnt/consplusregion
chmod 777 /mnt/kodeks_client

echo Подключение к сетевым дискам!!!
echo -n "Имя пользователя ?: "
read profil_user
echo -n "Пароль пользователя ?: "
read paroll_user

read -p "Base (y/n): " slovo
echo $slovo

if [ $slovo == y ];
then
printf "\n//law/base /mnt/base cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
fi

read -p "Mail (y/n): " slovo
echo $slovo

if [ $slovo == y ];
then
printf "//fsrv/mail /mnt/mail cifs vers=2.0,domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
fi

read -p "Consplus (y/n): " slovo
echo $slovo

if [ $slovo == y ];
then
printf "//cons/consplus /mnt/consplus cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
fi

read -p "consplusregion (y/n): " slovo
echo $slovo

if [ $slovo == y ];
then
printf "//cons/consplusregion /mnt/consplusregion cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
fi

read -p "kodeks_client y/n: " slovo
echo $slovo

if [ $slovo == y ];
then
printf "//cons/kodeks_client /mnt/kodeks_client cifs vers=2.0,domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n" | sudo tee -a /etc/fstab
fi
echo Попытка подключения прошла успешно. Рекомендую проверить!!!!

sudo cp ./mnt-base.automount /etc/systemd/system
sudo cp ./mnt-consplus.automount /etc/systemd/system
sudo cp ./mnt-consplusregion.automount /etc/systemd/system
sudo cp ./mnt-mail.automount /etc/systemd/system
sudo cp ./mnt-kodeks_client.automount /etc/systemd/system
systemctl enable --now mnt-base.automount
systemctl enable --now mnt-consplus.automount
systemctl enable --now mnt-consplusregion.automount
systemctl enable --now mnt-mail.automount
systemctl enable --now mnt-kodeks_client.automount

sudo apt -y autoremove
