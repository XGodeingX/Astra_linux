#!/usr/bin/env bash

domain_setup() {
    set -e
    local profile
    profile=$(whiptail --inputbox "Учётная запись администратора домена (например, Администратор):" 12 65 3>&1 1>&2 2>&3) || return

    whiptail --msgbox "Будет запрошен пароль администратора домена" 10 60

    if ! sudo apt install -y astra-ad-sssd-client; then
        whiptail --msgbox "❌ Не удалось установить astra-ad-sssd-client." 10 50
        return 1
    fi

    if ! sudo astra-ad-sssd-client -d adm.local -u "$profile" -y; then
        whiptail --msgbox "❌ Не удалось присоединиться к домену." 10 50
        return 1
    fi

    set +e
    msg_done "Присоединение к домену завершено. Перезагрузите систему."
}