#!/usr/bin/env bash

install_programs() {
    set -e

    # Относительный путь к папке с .deb
    local deb_dir="/home/admoi/Desktop/AstraLinux_Guide/Programs"

    # Установка из репозитория
    if ! sudo apt install -y seahorse yandex-browser-stable cifs-utils htop glmark2 \
        fly-admin-samba libusb-0.1-4 icoutils libcupsimage2 wine winetricks \
        libmspack0 cabextract zenity; then
        whiptail --msgbox "❌ Ошибка установки пакетов из репозитория." 10 50
        return 1
    fi

    # Установка .deb-файлов
    if [[ -d "$deb_dir" ]]; then
        if ! sudo dpkg -i "$deb_dir"/*.deb 2>/dev/null; then
            sudo apt --fix-broken install -y
        fi
        sudo apt autoremove -y
    else
        whiptail --msgbox "ℹ️ Папка Programs не найдена. Установка .deb пропущена." 10 60
    fi

    set +e
    msg_done "Установка программ завершена"
}
