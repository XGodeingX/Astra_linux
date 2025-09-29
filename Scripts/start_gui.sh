#!/bin/bash

# Проверка наличия whiptail
if ! command -v whiptail &> /dev/null; then
    echo "Установка whiptail..."
    sudo apt-get install whiptail -y
fi

main_menu() {
    while true; do
        choice=$(whiptail --title "Главное меню" \
            --menu "Выберите один из вариантов:" 20 60 10 \
            "0" "Установка и подключение пользователя к домену (перезагрузка)" \
            "1" "Обновление репозиториев Астра Линукс и полное обновление" \
            "2" "Установка программ из репозиториев и DEB файлов" \
            "3" "Настройки для Справки-БК" \
            "4" "Подключение сетевых дисков" \
            "5" "Разрешения для флешек и компакт-дисков" \
            "6" "Удаление старых ядер (перезагрузка)" \
            "7" "Выход" 3>&1 1>&2 2>&3)
        
        if [ $? -ne 0 ]; then
            exit 0
        fi
        
        case $choice in
            0) domain_setup ;;
            1) update_repos_menu ;;
            2) install_programs ;;
            3) spravka_bk_setup ;;
            4) network_drives ;;
            5) usb_cd_permissions ;;
            6) remove_old_kernels ;;
            7) exit 0 ;;
        esac
    done
}

domain_setup() {
    profil_name=$(whiptail --inputbox "Какой профиль будет вноситься в домен?" 10 60 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then return; fi
    
    whiptail --title "Установка домена" --msgbox "Начинается установка доменных пакетов..." 10 60
    
    sudo apt install -y fly-admin-ad-sssd-client astra-ad-sssd-client
    sudo apt autoremove -y
    
    if sudo astra-ad-sssd-client -d adm.local -u "$profil_name"; then
        whiptail --title "Успех" --msgbox "Домен настроен успешно! Требуется перезагрузка." 10 60
    else
        whiptail --title "Ошибка" --msgbox "Ошибка при настройке домена!" 10 60
    fi
}

update_repos_menu() {
    while true; do
        chir=$(whiptail --title "Обновление репозиториев" \
            --menu "Выберите версию Астра Линукс:" 15 50 4 \
            "1" "Астра Линукс 1.7" \
            "2" "Астра Линукс 1.8" \
            "3" "Назад" 3>&1 1>&2 2>&3)
        
        if [ $? -ne 0 ]; then break; fi
        
        case $chir in
            1)
                whiptail --title "Обновление 1.7" --msgbox "Настраиваю репозитории для Астра Линукс 1.7..." 10 60
                
                echo "# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC" | sudo tee /etc/apt/sources.list
                echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 non-free contrib main" | sudo tee -a /etc/apt/sources.list
                echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list
                echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list
                echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list
                
                sudo apt update
                sudo astra-update -A -r -T
                sudo apt autoremove -y
		sudo apt --fix-broken install -y
                
                whiptail --title "Готово" --msgbox "Обновление для Астра Линукс 1.7 завершено!" 10 60
                ;;
            2)
                whiptail --title "Обновление 1.8" --msgbox "Настраиваю репозитории для Астра Линукс 1.8..." 10 60
                
                echo "# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC" | sudo tee /etc/apt/sources.list
                echo "deb https://dl.astralinux.ru/astra/stable/1.8_x86-64/main-repository/     1.8_x86-64 main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
                echo "deb https://dl.astralinux.ru/astra/stable/1.8_x86-64/extended-repository/ 1.8_x86-64 main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
                
                sudo apt update
                sudo astra-update -A -r -T
                sudo apt autoremove -y
		sudo apt --fix-broken install -y
                
                whiptail --title "Готово" --msgbox "Обновление для Астра Линукс 1.8 завершено!" 10 60
                ;;
            3)
                break
                ;;
        esac
    done
}

install_programs() {
    whiptail --title "Установка программ" --msgbox "Начинается установка программ..." 10 60
    
    # Проверка существования директории с DEB файлами
    if [ -d "/home/admoi/Desktop/AstraLinux_Guide/Программы" ]; then
        sudo dpkg -i /home/admoi/Desktop/AstraLinux_Guide/Программы/*.deb
    else
        whiptail --title "Внимание" --msgbox "Директория с DEB файлами не найдена!" 10 60
    fi
    
    sudo apt install -y seahorse yandex-browser-stable cifs-utils htop glmark2 \
        fly-admin-samba libusb-0.1-4 icoutils libcupsimage2 wine winetricks \
        libmspack0 cabextract zenity
    
    sudo apt --fix-broken install -y
    sudo apt autoremove -y
    
    whiptail --title "Готово" --msgbox "Установка программ завершена!" 10 60
}

spravka_bk_setup() {
    whiptail --title "Настройка Справки-БК" --msgbox "Выполняю настройки для Справки-БК..." 10 60
    
    sudo apt install -y libpaper-utils printer-driver-cups-pdf system-config-printer \
        cups-x2go ttf-mscorefonts-installer fonts-freefont-ttf
    
    systemctl disable sssd
    astra-ptrace-lock disable
    
    whiptail --title "Готово" --msgbox "Настройки для Справки-БК выполнены!" 10 60
}

network_drives() {
    profil_user=$(whiptail --inputbox "Имя пользователя для сетевых дисков:" 10 60 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then return; fi
    
    paroll_user=$(whiptail --passwordbox "Пароль пользователя:" 10 60 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then return; fi
    
    # Создаем директории для монтирования
    sudo mkdir -p /mnt/{base,mail,consplus,consplusregion,kodeks_client}
    
    # Функция для добавления точек монтирования
    add_mount_point() {
        local name=$1
        local path=$2
        local options=$3
        
        if whiptail --yesno "Подключить сетевой диск $name?" 10 60; then
            echo "$path /mnt/$name $options" | sudo tee -a /etc/fstab
            
            # Создаем automount unit файл
            cat > /tmp/mnt-$name.automount << EOF
[Unit]
Description=Automount for $name
After=network.target

[Automount]
Where=/mnt/$name
TimeoutIdleSec=30

[Install]
WantedBy=multi-user.target
EOF
            
            sudo cp /tmp/mnt-$name.automount /etc/systemd/system/
            sudo systemctl enable --now mnt-$name.automount
        fi
    }
    
    add_mount_point "base" "//law/base" "cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0"
    add_mount_point "mail" "//fsrv/mail" "cifs vers=2.0,domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0"
    add_mount_point "consplus" "//cons/consplus" "cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0"
    add_mount_point "consplusregion" "//cons/consplusregion" "cifs domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0"
    add_mount_point "kodeks_client" "//cons/kodeks_client" "cifs vers=2.0,domain=adm.local,username=$profil_user,password=$paroll_user,iocharset=utf8,file_mode=0777,dir_mode=0777,rw 0 0"
    
    whiptail --title "Готово" --msgbox "Настройка сетевых дисков завершена!" 10 60
}

usb_cd_permissions() {
    profil_name=$(whiptail --inputbox "Имя пользователя? Пример (user@domen):" 10 60 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then return; fi
    
    sudo usermod -aG floppy "$profil_name"
    sudo usermod -aG cdrom "$profil_name"
    
    whiptail --title "Готово" --msgbox "Разрешения для пользователя $profil_name установлены!" 10 60
}

remove_old_kernels() {
    if whiptail --yesno "Вы уверены, что хотите удалить старые ядра? Это потребует перезагрузки." 10 60; then
        pkgs=$(dpkg -l 2> /dev/null | egrep "^ii\s*linux-image-[456]\.[[:digit:]]+\.[[:digit:]]+-[[:digit:]]+-" | \
               cut -d " " -f3 | grep -v "^linux-image-$(uname -r | cut -d '-' -f1-2)")
        
        if [ -n "$pkgs" ]; then
            sudo apt remove -y $pkgs
            sudo rm -f /boot/old-*
            whiptail --title "Готово" --msgbox "Старые ядра удалены! Требуется перезагрузка." 10 60
        else
            whiptail --title "Информация" --msgbox "Старые ядра не найдены." 10 60
        fi
    fi
}

# Запуск главного меню
main_menu