#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_USER_FOR_LUCY=${DB_USER_FOR_LUCY:-lucy}
DB_PASS_FOR_LUCY=${DB_PASS_FOR_LUCY:-lucypass}
DB_NAME_FOR_LUCY=${DB_NAME_FOR_LUCY:-lucy}

echo ">> [NET] Creando/asegurando red externa 'campus'..."
docker network create campus >/dev/null 2>&1 || true
docker network ls | grep -E '(^|\s)campus(\s|$)' >/dev/null || { echo "!! No se pudo crear la red 'campus'"; exit 1; }

echo ">> [UP] Levantando VECO (Moodle+DB+pma+cron) ..."
cd "$ROOT_DIR"
docker compose up -d

# Asegurar que el contenedor de DB está en la red 'campus' con alias 'veco-db'
echo ">> [NET] Asegurando que DB está conectado a 'campus' con alias 'veco-db'..."
DB_CONT="$(docker compose ps -q db || true)"
if [ -z "${DB_CONT}" ]; then
  echo "!! No encuentro el contenedor de DB. Revisá 'docker compose ps'."
  exit 1
fi

# Conectar con alias (si ya está conectado, no falla gracias al '|| true')
docker network connect --alias veco-db campus "$DB_CONT" >/dev/null 2>&1 || true

echo ">> [CHK] Miembros en red 'campus':"
docker network inspect campus --format '{{range .Containers}}{{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}' | sort

# Probar conectividad MySQL desde la red (cliente efímero)
echo ">> [CHK] Probando acceso MySQL a 'veco-db:3306'..."
if ! docker run --rm --network campus mariadb:10.11 \
      mysql -h veco-db -P 3306 -u "${DB_USER_FOR_LUCY}" -p"${DB_PASS_FOR_LUCY}" -e "SELECT 1;" >/dev/null 2>&1; then
  echo ">> [DB] Creando DB/usuario '${DB_NAME_FOR_LUCY}' / '${DB_USER_FOR_LUCY}' (si no existen)..."
  docker compose exec db sh -lc "mysql -uroot -p\"\$MYSQL_ROOT_PASSWORD\" -e \"
    CREATE DATABASE IF NOT EXISTS ${DB_NAME_FOR_LUCY} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '${DB_USER_FOR_LUCY}'@'%' IDENTIFIED BY '${DB_PASS_FOR_LUCY}';
    GRANT ALL PRIVILEGES ON ${DB_NAME_FOR_LUCY}.* TO '${DB_USER_FOR_LUCY}'@'%';
    FLUSH PRIVILEGES;\""
fi

# Reintentar prueba
docker run --rm --network campus mariadb:10.11 \
  mysql -h veco-db -P 3306 -u "${DB_USER_FOR_LUCY}" -p"${DB_PASS_FOR_LUCY}" -e "SELECT 1;" \
  && echo ">> [OK] MySQL accesible en red interna (veco-db:3306)." \
  || { echo "!! No pude conectar a MySQL en 'veco-db:3306'. Revisá red/credenciales."; exit 1; }

# Mostrar URLs útiles
echo
echo ">> Servicios:"
echo "  - Moodle:      http://localhost:8080"
# Nota: si cambiás el puerto de pma en el compose, actualizá esta línea:
echo "  - phpMyAdmin:  http://localhost:8083  (Host: db, Usuario/Pass segun tu .env)"
echo
echo ">> Listo. Lucy/Samuel pueden usar en sus .env:"
echo "   DB_HOST=veco-db"
echo "   DB_PORT=3306"
echo "   DB_DATABASE=${DB_NAME_FOR_LUCY}"
echo "   DB_USERNAME=${DB_USER_FOR_LUCY}"
echo "   DB_PASSWORD=${DB_PASS_FOR_LUCY}"

