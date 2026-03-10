#!/usr/bin/env bash

check_whiptail() {
    if ! command -v whiptail &>/dev/null; then
        if ! sudo apt-get update && sudo apt-get install -y whiptail; then
            return 1
        fi
    fi
    return 0
}

msg_done() {
    whiptail --title "Готово" --msgbox "${1:-Операция завершена}" 8 60
}