#!/usr/bin/env bash
set -euo pipefail

# Проверка: запущен ли от root?
if [[ $EUID -ne 0 ]]; then
    echo "❌ Этот скрипт должен запускаться через sudo." >&2
    exit 1
fi

# Определяем корень проекта
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/modules/utils.sh"
source "$SCRIPT_DIR/modules/menu.sh"
source "$SCRIPT_DIR/modules/domain.sh"
source "$SCRIPT_DIR/modules/update.sh"
source "$SCRIPT_DIR/modules/programs.sh"
source "$SCRIPT_DIR/modules/spravka.sh"
source "$SCRIPT_DIR/modules/network.sh"
source "$SCRIPT_DIR/modules/permissions.sh"
source "$SCRIPT_DIR/modules/kernels.sh"
source "$SCRIPT_DIR/modules/auto_domain.sh"
source "$SCRIPT_DIR/modules/update_smb_creds.sh"

check_whiptail || { echo "❌ whiptail не установлен."; exit 1; }
main_menu