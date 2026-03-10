#!/usr/bin/env bash

# Модуль: Просмотр и обновление учётных данных для сетевых дисков
# Файл: ./modules/update_smb_creds.sh

update_smb_creds() {
    local mounts=(
        "base|//law/base"
        "mail|//fsrv/mail"
        "consplus|//cons/consplus"
        "consplusregion|//cons/consplusregion"
        "kodeks_client|//cons/kodeks_client"
    )

    if [[ $EUID -ne 0 ]]; then
        whiptail --msgbox "❌ Требуются права root." 10 50
        return 1
    fi

    while true; do
        # === ШАГ 1: Выбор диска ===
        local choices=()
        for item in "${mounts[@]}"; do
            name="${item%%|*}"
            path="${item##*|}"
            choices+=("$name" "$path")
        done

        local selected
        selected=$(whiptail --menu "Выберите диск для просмотра/изменения:" 18 65 10 \
            "${choices[@]}" 3>&1 1>&2 2>&3) || return

        local cred_file="/root/.smbcred_$selected"

        # === ШАГ 2: Проверка существования файла ===
        if [[ ! -f "$cred_file" ]]; then
            whiptail --msgbox "❌ Файл учётных данных не найден:\n$cred_file" 12 60
            continue
        fi

        # === ШАГ 3: Показ текущих данных ===
        local current_user current_pass current_domain
        current_user=$(grep -E '^username=' "$cred_file" | cut -d'=' -f2)
        current_pass=$(grep -E '^password=' "$cred_file" | cut -d'=' -f2)
        current_domain=$(grep -E '^domain=' "$cred_file" | cut -d'=' -f2)

        local info_text="Диск: $selected\nПользователь: ${current_user:-<не задан>}\nДомен: ${current_domain:-<не задан>}"

        if whiptail --yesno "Текущие данные:\n$info_text\n\nПоказать пароль?" 14 60 3>&1 1>&2 2>&3; then
            info_text+="\nПароль: $current_pass"
        fi

        whiptail --msgbox "Текущие учётные данные:\n\n$info_text" 16 60

        # === ШАГ 4: Спрашиваем, изменять ли ===
        if ! whiptail --yesno "Изменить учётные данные для '$selected'?" 10 50 3>&1 1>&2 2>&3; then
            continue
        fi

        # === ШАГ 5: Запрос новых данных ===
        local new_user new_pass
        new_user=$(whiptail --inputbox "Новое имя пользователя:" 10 60 "$current_user" 3>&1 1>&2 2>&3) || continue
        new_pass=$(whiptail --passwordbox "Новый пароль:" 10 60 3>&1 1>&2 2>&3) || continue

        # === ШАГ 6: Обновление файла ===
        local tmp_file="/tmp/.smbcred_${selected}_$$.tmp"
        {
            echo "username=$new_user"
            echo "password=$new_pass"
            echo "domain=adm.local"
        } > "$tmp_file"

        if sudo install -m 600 -o root -g root "$tmp_file" "$cred_file" 2>/dev/null; then
            rm -f "$tmp_file"
            msg_done "✅ Учётные данные для '$selected' обновлены!"

            # Перемонтировать?
            if whiptail --yesno "Перемонтировать диск '$selected' сейчас?" 10 50 3>&1 1>&2 2>&3; then
                if mountpoint -q "/mnt/$selected"; then
                    umount "/mnt/$selected" 2>/dev/null || true
                fi
                if systemctl is-active --quiet "mnt-$selected.automount"; then
                    systemctl restart "mnt-$selected.automount"
                    whiptail --msgbox "Диск перезапущен через automount." 10 50
                else
                    mount "/mnt/$selected" && \
                        whiptail --msgbox "Диск успешно перемонтирован." 10 50 || \
                        whiptail --msgbox "Ошибка монтирования!" 10 50
                fi
            fi
            # Возвращаемся к выбору диска
            continue
        else
            rm -f "$tmp_file"
            whiptail --msgbox "❌ Ошибка при обновлении файла." 10 50
            # Возвращаемся к выбору диска
            continue
        fi
    done
}
