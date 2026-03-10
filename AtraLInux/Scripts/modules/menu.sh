# modules/menu.sh
#!/usr/bin/env bash

main_menu() {
    while true; do
        local choice
        exec 3>&1
        choice=$(whiptail --title "Главное меню" \
            --menu "Выберите действие:" 22 65 12 \
            "1"  "Обновление системы" \
            "2"  "Установка программ" \
            "3"  "Присоединение к домену" \
            "4"  "Автовход в домен" \
            "5"  "Сетевые диски" \
            "6"  "Учётные данные к дискам"\
            "7"  "Права на USB/CD" \
            "8"  "Настройки Справки-БК" \
            "9"  "Удаление старых ядер" \
            "10"  "Выход" \
            2>&1 1>&3) || { exec 3>&-; exit 0; }
        exec 3>&-

        case $choice in
            1) update_repos_menu ;;
            2) install_programs ;;
            3) domain_setup ;;
            4) auto_domain_login ;;
            5) network_drives ;;
            6) update_smb_creds ;;
            7) usb_cd_permissions ;;
            8) spravka_bk_setup ;;
            9) remove_old_kernels ;;
            10) exit 0 ;;
            "") continue ;;  # Отмена (Esc, Cancel, закрытие окна)
            *) continue ;;   # Непредвиденный ввод
        esac
    done
}
