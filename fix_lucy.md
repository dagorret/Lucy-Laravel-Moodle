# lucy/.env (ajusta también APP_URL a tu IP/puerto si querés):

```
APP_URL=http://200.7.134.12:8081

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=lucy
DB_USERNAME=lucy
DB_PASSWORD=lucypass
```

# Limpiá cachés de configuración (si no, seguirá usando SQLite):

```
docker compose exec lucy php /app/artisan config:clear
docker compose exec lucy php /app/artisan optimize:clear
```

# crear la DB y usuario

```
docker compose exec db mysql -uroot -prootpass -e "\
CREATE DATABASE IF NOT EXISTS lucy CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; \
CREATE USER IF NOT EXISTS 'lucy'@'%' IDENTIFIED BY 'lucypass'; \
GRANT ALL PRIVILEGES ON lucy.* TO 'lucy'@'%'; FLUSH PRIVILEGES;"
```

# Como uso SESSION_DRIVER=database, crea tablas y  migrar:

```
docker compose exec lucy php /app/artisan session:table
docker compose exec lucy php /app/artisan cache:table
docker compose exec lucy php /app/artisan queue:table
docker compose exec lucy php /app/artisan migrate --force
```

# Probar

```
docker compose exec lucy php /app/artisan tinker --execute="DB::connection()->getPdo(); echo 'DB OK'.PHP_EOL;"
```


# Quedarse en SQLite

```
docker compose exec lucy bash -lc '
mkdir -p /app/database &&
touch /app/database/database.sqlite &&
chown application:application /app/database/database.sqlite &&
chmod ug+rw /app/database/database.sqlite
```

# En lucy/.env

```
DB_CONNECTION=sqlite
DB_DATABASE=/app/database/database.sqlite
```

# cachés y migra (si sesiones en DB):

```
docker compose exec lucy php /app/artisan config:clear
docker compose exec lucy php /app/artisan session:table
docker compose exec lucy php /app/artisan migrate --force
```





