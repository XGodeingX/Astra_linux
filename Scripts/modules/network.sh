#!/usr/bin/env bash

network_drives() {
    set -e

    if ! command -v mount.cifs &>/dev/null; then
        whiptail --msgbox "❌ Требуется пакет cifs-utils." 10 50
        return 1
    fi

    local profil_user paroll_user
    profil_user=$(whiptail --inputbox "Имя пользователя:" 10 60 3>&1 1>&2 2>&3) || return
    paroll_user=$(whiptail --passwordbox "Пароль:" 10 60 3>&1 1>&2 2>&3) || return

    sudo mkdir -p /mnt/{base,mail,consplus,consplusregion,kodeks_client}

    add_mount_point() {
        local name=$1 path=$2 version=$3
        if ! whiptail --yesno "Подключить $name?" 10 60 3>&1 1>&2 2>&3; then
            return 0
        fi

        local tmp_cred="/tmp/.smbcred_$name"
        {
            echo "username=$profil_user"
            echo "password=$paroll_user"
            echo "domain=adm.local"
        } > "$tmp_cred"

        sudo install -m 600 -o root -g root "$tmp_cred" "/root/.smbcred_$name"
        rm -f "$tmp_cred"

        local opts="credentials=/root/.smbcred_$name,vers=$version,iocharset=utf8,file_mode=0660,dir_mode=0770,rw,noperm"
        echo "$path /mnt/$name cifs $opts 0 0" | sudo tee -a /etc/fstab >/dev/null

        cat > "/tmp/mnt-$name.automount" << EOF
[Unit]
Description=Automount $name
[Automount]
Where=/mnt/$name
TimeoutIdleSec=900
[Install]
WantedBy=multi-user.target
EOF
        sudo mv "/tmp/mnt-$name.automount" /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable --now "mnt-$name.automount"
    }

    add_mount_point "base"           "//law/base"           "1.0"
    add_mount_point "mail"           "//fsrv/mail"          "1.0"
    add_mount_point "consplus"       "//cons/consplus"      "1.0"
    add_mount_point "consplusregion" "//cons/consplusregion" "1.0"
    add_mount_point "kodeks_client"  "//cons/kodeks_client" "2.0"

    unset -f add_mount_point
    set +e
    msg_done "Сетевые диски настроены"
}