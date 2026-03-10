#!/usr/bin/env bash

auto_domain_login() {
    local SSSD_CONF="/etc/sssd/sssd.conf"
    local DOMAIN_NAME="adm.local"

    if [[ ! -f "$SSSD_CONF" ]]; then
        whiptail --msgbox "❌ Файл $SSSD_CONF не найден.\nУбедитесь, что система присоединена к домену." 14 60
        return 1
    fi

    if ! grep -q "^\[domain/$DOMAIN_NAME\]" "$SSSD_CONF"; then
        whiptail --msgbox "❌ Секция [domain/$DOMAIN_NAME] не найдена в $SSSD_CONF." 14 60
        return 1
    fi

    local BACKUP="${SSSD_CONF}.backup_$(date +%Y%m%d_%H%M%S)"
    cp "$SSSD_CONF" "$BACKUP"

    chmod 600 "$SSSD_CONF"

    set_sssd_param() {
        local section="$1" param="$2" value="$3"
        local esc_section=$(printf '%s' "$section" | sed 's/[[\.*^$/]/\\&/g')
        local esc_param=$(printf '%s' "$param" | sed 's/[[\.*^$()+?{|]/\\&/g')
        sed -i "/^\[$esc_section\]/,/^\[.*\]/ { /^[[:space:]]*$esc_param[[:space:]]*=/d; }" "$SSSD_CONF"
        sed -i "/^\[$esc_section\]/ a\\
$param = $value
" "$SSSD_CONF"
    }

    set_sssd_param "sssd" "default_domain" "$DOMAIN_NAME"
    set_sssd_param "domain/$DOMAIN_NAME" "use_fully_qualified_names" "false"

    chmod 600 "$SSSD_CONF"
    chown root:root "$SSSD_CONF"
    systemctl restart sssd

    msg_done "Автоматический вход в домен '$DOMAIN_NAME' настроен!\nРезервная копия: $(basename "$BACKUP")"
}