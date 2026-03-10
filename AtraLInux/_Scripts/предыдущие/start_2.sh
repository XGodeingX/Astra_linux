#!/bin/bash

main_menu() {
    clear
    echo "Выберите один из вариантов:"
    echo "0) Установка и подключение пользователя к домену (перезагрузка)"
    echo "1) Обновление репозиториев для Астра линукс и полное обновлнение из репозиториев"
    echo "2) Установка програм с репозиториев и с /home/admoi/Desktop/AstraLinux_Guide/Программы/*.deb"
    echo "3) Настройки для Справки-БК."
    echo "4) Подключение сетевых дисков."
    echo "5) Разрешения примонтировать флешки с компакт-диском (запускаем после инициализации пользователя!!!)"
    echo "6) Удаление старых ядер (перезагрузка)"
    echo "7) Выход"
    read -p "Введите свой выбор [0-7]: " choice

    case $choice in
        0)
            echo "Вы выбрали установка и подключение пользователя к домену"
            echo -n "Какой профиль будет вноситься в домен?: "
            read profil_name
                sudo apt install fly-admin-ad-client
                sudo apt install astra-ad-sssd-client
                sudo apt install fly-admin-ad-sssd-client
                sudo apt autoremove
                sudo astra-ad-sssd-client -d adm.local -u $profil_name
            read -p "Press Enter to continue..."
            ;;
        1)
            while true; do
                clear
                echo "Выберите один из вариантов:"
                echo "1) Обновление репозиториев для Астра линукс 1.7"
                echo "2) Обновление репозиториев для Астра линукс 1.8"
                echo "3) Выход"
                read -p "Введите свой выбор [1-3]: " chir

                case $chir in
            1)
                echo "Вы выбрали обновление репозиториев для Астра линукс 1.7"
                    echo "# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC" | sudo tee /etc/apt/sources.list
                    echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 non-free contrib main" | sudo tee -a /etc/apt/sources.list
                    echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list
                    echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list
                    echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list
                    sudo apt update
                    sudo astra-update -A -r -T
                    sudo apt autoremove
                read -p "Press Enter to continue..."
                ;;
            2)
                echo "Вы выбрали обновление репозиториев для Астра линукс 1.8"
                    echo "# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC" | sudo tee /etc/apt/sources.list
                    echo "deb https://dl.astralinux.ru/astra/stable/1.8_x86-64/main-repository/     1.8_x86-64 main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
                    echo "deb https://dl.astralinux.ru/astra/stable/1.8_x86-64/extended-repository/ 1.8_x86-64 main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
                    sudo apt update
                    sudo astra-update -A -r -T
                    sudo apt autoremove
                read -p "Press Enter to continue..."
                ;;
            3)
                main_menu
                echo "Выход..."
                ;;
            *)
                echo "Неверный выбор! Выберите один из вариантов."
                read -p "Press Enter to continue..."
                esac
            done
            ;;
        2)
            echo "Установка програм с репозиториев и с /home/admoi/Desktop/AstraLinux_Guide/Программы/*.deb!"
                sudo dpkg -i /home/admoi/Desktop/AstraLinux_Guide/Программы/*.deb
                sudo apt install -y seahorse yandex-browser-stable cifs-utils htop glmark2 fly-admin-samba libusb-0.1-4 icoutils libcupsimage2
                sudo apt install -y wine winetricks libmspack0 cabextract zenity -fy
                sudo apt --fix-broken install
                sudo apt -y autoremove
            read -p "Press Enter to continue..."
            ;;
        3)
            echo "Вы выбрали Настройки для Справки-БК!"
            sudo apt install -y libpaper-utils printer-driver-cups-pdf system-config-printer cups-x2go ttf* fonts* -fy
            systemctl disable sssd
            astra-ptrace-lock disable
            read -p "Press Enter to continue..."
            ;;
        4)
            echo "Вы выбрали подключение сетевых дисков!"
                echo -n "Имя пользователя ?: "
                read profil_user
                echo -n "Пароль пользователя ?: "
                read paroll_user

                read -p "Base (y/n): " slovo
                echo $slovo

                    if [ $slovo == y ];
                    then
                        printf "\n//law/base /mnt/base cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
                        sudo cp ./mnt-base.automount /etc/systemd/system
                        systemctl enable --now mnt-base.automount
                    fi

                read -p "Mail (y/n): " slovo
                echo $slovo

                    if [ $slovo == y ];
                    then
                        printf "//fsrv/mail /mnt/mail cifs vers=2.0,domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
                        sudo cp ./mnt-mail.automount /etc/systemd/system
                        systemctl enable --now mnt-mail.automount
                    fi

                read -p "Consplus (y/n): " slovo
                echo $slovo

                    if [ $slovo == y ];
                    then
                        printf "//cons/consplus /mnt/consplus cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
                        sudo cp ./mnt-consplus.automount /etc/systemd/system
                        systemctl enable --now mnt-consplus.automount
                    fi

                read -p "consplusregion (y/n): " slovo
                echo $slovo

                    if [ $slovo == y ];
                    then
                        printf "//cons/consplusregion /mnt/consplusregion cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n\n" | sudo tee -a /etc/fstab
                        sudo cp ./mnt-consplusregion.automount /etc/systemd/system
                        systemctl enable --now mnt-consplusregion.automount
                    fi

                read -p "kodeks_client y/n: " slovo
                echo $slovo

                    if [ $slovo == y ];
                    then
                        printf "//cons/kodeks_client /mnt/kodeks_client cifs vers=2.0,domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0\n" | sudo tee -a /etc/fstab
                        sudo cp ./mnt-kodeks_client.automount /etc/systemd/system
                        systemctl enable --now mnt-kodeks_client.automount
                    fi
            read -p "Press Enter to continue..."
            main_menu
            ;;
        5)
            echo "Вы выбрали разрешения примонтировать флешки с компакт-диском!"
            echo -n "Имя пользователя? Пример (user@domen): "
            read profil_name
                sudo usermod -aG floppy $profil_name
                sudo usermod -aG cdrom $profil_name
            read -p "Press Enter to continue..."
            ;;
        6)
            echo "Вы выбрали удаление старых ядер!"
            sudo su
            pkgs=`dpkg -l 2> /dev/null | egrep "^ii\s*linux-image-[456]\.[[:digit:]]+\.[[:digit:]]+-[[:digit:]]+-" | cut -d " " -f3 | grep -v ^linux-image-$(uname -r | cut -d '-' -f1-2)`
            set -e
            [ -n "$pkgs" ] && apt remove $pkgs
            rm -f /boot/old-*
            read -p "Press Enter to continue..."
            ;;
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Неверный выбор! Выберите один из вариантов."
            read -p "Press Enter to continue..."
            ;;
    esac
}

main_menu
