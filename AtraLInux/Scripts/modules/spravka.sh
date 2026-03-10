#!/usr/bin/env bash

spravka_bk_setup() {
    if ! whiptail --yesno "Это отключит вход в домен!\nПродолжить?" 10 50; then
        return
    fi

    set -e
    sudo apt install -y libpaper-utils printer-driver-cups-pdf system-config-printer \
        cups-x2go ttf-mscorefonts-installer fonts-freefont-ttf

    sudo systemctl disable --now sssd
    sudo astra-ptrace-lock disable
    set +e
    msg_done "Настройки Справки-БК завершены"
}