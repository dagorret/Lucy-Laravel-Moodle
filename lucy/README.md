# Lucy Dev Stack (Laravel + PHP 8.2 + Node 20 + Composer + MySQL + phpMyAdmin)

## Puertos
- Web (Laravel): http://<host>:8080
- phpMyAdmin: http://<host>:8081
- MySQL (host): 3306

## Primer uso
```bash
# Cargar alias
source aliases_lucy.sh

# Levantar
lucy up

# Instalar deps (si es un proyecto nuevo)
lucy composer install
lucy artisan key:generate
lucy node install
lucy node run build   # o run dev para modo watch
```

## Notas
- El contenedor se ejecuta como UID/GID 1001 para que permisos sean transparentes.
- En producción, considere cambiar USER a www-data y no mapear puertos de DB a host.
- Este stack puede alinearse con Laravel Sail, pero aquí se provee un Dockerfile autocontenible.
