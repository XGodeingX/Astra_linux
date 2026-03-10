#!/usr/bin/env bash

update_repos_menu() {
    while true; do
        local choice
        choice=$(whiptail --title "Обновление репозиториев" \
            --menu "Версия Astra Linux:" 15 50 4 \
            "1" "1.7" \
            "2" "1.8" \
            "3" "Назад" 3>&1 1>&2 2>&3) || break

        case $choice in
            1)
                set -e
                sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup_$(date +%Y%m%d)
                sudo tee /etc/apt/sources.list >/dev/null << 'EOF'
# Astra Linux repository https://wiki.astralinux.ru/x/0oLiC
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 non-free contrib main
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free
EOF
                sudo apt update
                sudo astra-update -A -r -T
                sudo apt autoremove -y
                sudo apt --fix-broken install -y
                set +e
                msg_done "Обновление 1.7 завершено"
                ;;
            2)
                set -e
                sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup_$(date +%Y%m%d)
                sudo tee /etc/apt/sources.list >/dev/null << 'EOF'
# Astra Linux repository https://wiki.astralinux.ru/x/0oLiC
deb https://dl.astralinux.ru/astra/stable/1.8_x86-64/main-repository/ 1.8_x86-64 main contrib non-free non-free-firmware
deb https://dl.astralinux.ru/astra/stable/1.8_x86-64/extended-repository/ 1.8_x86-64 main contrib non-free non-free-firmware
EOF

            # Фиксация пакетов
            sudo apt-mark hold \
                linux-6.1-generic \
                linux-astra-modules-6.1.90-1-generic \
                linux-headers-6.1-generic \
                linux-headers-6.1.90-1 \
                linux-headers-6.1.90-1-generic \
                linux-image-6.1-generic \
                linux-image-6.1.90-1-generic
                sudo apt update
                sudo astra-update -A -r -T
                sudo apt autoremove -y
                sudo apt --fix-broken install -y
                set +e
                msg_done "Обновление 1.8 завершено.\nРезервная копия: /etc/apt/sources.list.backup_*"
                ;;
            3) break ;;
        esac
    done
}
