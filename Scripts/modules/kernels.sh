#!/usr/bin/env bash

remove_old_kernels() {
    if ! whiptail --yesno "Удалить старые ядра? Требует перезагрузки." 10 60; then
        return
    fi

    set -e
    local current_kernel old_kernels

    current_kernel=$(uname -r)
    old_kernels=$(dpkg -l 'linux-image-*' 2>/dev/null | awk -v cur="$current_kernel" '
        /^ii/ && $2 ~ /^linux-image-[0-9]/ && $2 != "linux-image-generic" && index($2, cur) == 0 {print $2}
    ')

    if [[ -z "$old_kernels" ]]; then
        set +e
        msg_done "Старые ядра не найдены"
        return
    fi

    if ! sudo apt purge -y $old_kernels; then
        set +e
        whiptail --msgbox "❌ Ошибка удаления ядер." 10 50
        return 1
    fi

    sudo apt autoremove -y
    set +e
    msg_done "Старые ядра удалены. Перезагрузите систему."
}