#!/usr/bin/env bash
set -euo pipefail

# Ajusta permisos para que:
# - www-data (UID 33) pueda escribir en ./veco/moodledata y (opcional) en ./veco/moodle
# - el usuario host 1001 mantenga control de su código

MOODLE_DIR="veco/moodle"
MOODLEDATA_DIR="veco/moodledata"

# Crear si no existen
mkdir -p "$MOODLE_DIR" "$MOODLEDATA_DIR"

echo "[*] Propietario 1001:1001 en el código (host)"
sudo chown -R 1001:1001 "$MOODLE_DIR" || true

echo "[*] Propietario www-data (33:33) en moodledata (requerido)"
sudo chown -R 33:33 "$MOODLEDATA_DIR" || true

# ACLs finas: www-data rwx y se heredan nuevas entradas
if command -v setfacl >/dev/null 2>&1; then
  echo "[*] Aplicando ACLs para www-data sobre moodledata"
  sudo setfacl -R -m u:33:rwx -m d:u:33:rwx "$MOODLEDATA_DIR" || true

  echo "[*] (Opcional) ACLs para www-data sobre el código Moodle (solo si instala plugins/updates)"
  sudo setfacl -R -m u:33:rwx -m d:u:33:rwx "$MOODLE_DIR" || true
else
  echo "[!] 'setfacl' no disponible; se omiten ACLs. Considere instalar 'acl'."
fi

echo "[OK] Permisos listos."
