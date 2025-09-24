# Proyecto Moodle (Moodle + MariaDB + Cron + phpMyAdmin)

## Estructura
- `docker-compose.yml`: stack de Moodle.
- `Script/perm_moodle.sh`: adapta permisos para `www-data` (UID 33) y para el usuario host 1001.
- `Script/aliases_moodle.sh`: alias útiles para administrar el stack.

## Puertos
- Moodle web: http://<host>:8080
- MariaDB (host): 3307 (NO estándar, puede cambiarse)
- phpMyAdmin: http://<host>:8083

## Variables DB (por defecto)
- DB: moodle
- USER: moodle
- PASS: moodlepass
- ROOT PASS: rootpass

## Instalación rápida
```bash
# 1) Ajustar permisos del host para que sean transparentes entre UID 1001 y www-data (UID 33)
bash Script/perm_moodle.sh

# 2) Levantar stack
docker compose up -d

# 3) Ir a http://<host>:8080 y completar el instalador
```

## Notas de producción
- Considere un reverse proxy con HTTPS (nginx/caddy/traefik).
- Limite la exposición del puerto DB si no se requiere acceso externo (quite el mapping 3307:3306).
- Backups: detener `db`, respaldar `./veco/db`.
