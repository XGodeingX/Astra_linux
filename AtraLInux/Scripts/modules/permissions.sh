#!/usr/bin/env bash

usb_cd_permissions() {
    set -e
    local profil_name username
    profil_name=$(whiptail --inputbox "Имя пользователя (user или user@domen):" 10 60 3>&1 1>&2 2>&3) || return

    # Удаляем доменную часть, если есть
    username="${profil_name%@*}"

    if ! id "$username" &>/dev/null; then
        whiptail --msgbox "❌ Пользователь '$username' не существует." 10 50
        return 1
    fi

    sudo usermod -aG floppy,cdrom "$username"
    set +e
    msg_done "Права для $username назначены"
}