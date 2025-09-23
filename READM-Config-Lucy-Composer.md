# 1) Generar APP_KEY
docker compose exec lucy php artisan key:generate

# 2) Crear migraciones para sesiones/colas/cache (porque usás "database")
docker compose exec lucy php artisan session:table
docker compose exec lucy php artisan queue:table
docker compose exec lucy php artisan cache:table

# 3) Aplicar migraciones
docker compose exec lucy php artisan migrate

# 4) (opcional pero recomendado) Enlazar storage público
docker compose exec lucy php artisan storage:link


Notas rápidas

APP_URL debe coincidir con el puerto que expone el servicio lucy (8081 → http://localhost:8081).

Si preferís evitar migraciones al inicio, podés cambiar a:

SESSION_DRIVER=file

QUEUE_CONNECTION=sync

CACHE_STORE=file
y omitir los pasos 2 y 3; luego lo pasás a database cuando quieras.



# 1) Construí la nueva imagen y levantá todo
docker compose up -d --build lucy db web cron pma

# 2) (una sola vez) evitar "dubious ownership" dentro del contenedor
docker compose exec lucy bash -lc 'git config --system --add safe.directory /app'

# 3) Entrar a trabajar "todo desde uno"
docker compose exec lucy bash

# Composer / Laravel
composer install
php artisan key:generate
php artisan migrate

# Node / Vite (dev)
npm ci
npm run dev -- --host --port 5173
