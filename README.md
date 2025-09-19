# Proyecto Moodle + Lucy (Laravel)

Este entorno integra en **Docker Compose**:

- **Moodle** (`moodlehq/moodle-php-apache:8.2`)
- **Lucy (Laravel)** en `./lucy`
- **MariaDB** 10.11
- **phpMyAdmin** (puerto 8082)
- **MailHog** para pruebas de correo (puerto 8025)
- **Node.js** (para compilar assets de Lucy)
- **Composer** (para instalar dependencias PHP de Lucy)

---

## Servicios y puertos

- **Moodle (web)** → [http://localhost:8080](http://localhost:8080)
- **Lucy (Laravel web)** → [http://localhost:8081](http://localhost:8081)
- **phpMyAdmin** (base Moodle y Lucy) → [http://localhost:8082](http://localhost:8082)
- **MailHog** (captura de mails) → [http://localhost:8025](http://localhost:8025)

> ⚠️ Todos los puertos están accesibles en LAN/Internet.  
> Base de datos expuesta solo en `127.0.0.1:3306` (desde el host).

---

## Cómo iniciar el proyecto

### 1. Clonar el repositorio
```bash
git clone https://github.com/usuario/proyecto.git
cd proyecto
```

### 2. Levantar los servicios
```bash
./Script/start.sh
```

### 3. Verificar servicios
```bash
docker compose ps
```

---

## Lucy (Laravel)

### Agregar Laravel al directorio `lucy`

Si aún no tenés Laravel dentro de `lucy`, podés instalarlo con:

```bash
docker compose run --rm composer create-project laravel/laravel .
```

Este comando debe ejecutarse desde el directorio `lucy`:
```bash
cd lucy
docker compose run --rm composer create-project laravel/laravel .
```

Una vez instalado, asegurate de generar la APP_KEY y configurar `.env` con la base de datos `moodle` y MailHog.

### Generar APP_KEY
```bash
docker compose exec lucy php artisan key:generate
```

### Instalar dependencias PHP
```bash
docker compose exec composer composer install --no-interaction --prefer-dist
```

### Instalar dependencias JS
```bash
docker compose exec node npm ci
docker compose exec node npm run build
```

---

## Agregar un componente Laravel (ejemplo: Filament)

Puedes añadir componentes de Laravel directamente usando Composer.  
Ejemplo para instalar **Filament** (panel de administración):

```bash
docker compose exec composer composer require filament/filament:"^3.0"
```

Después, publicá los assets y configuraciones necesarias según la documentación oficial de Filament:

```bash
docker compose exec lucy php artisan vendor:publish --tag=filament-config
```

Esto agregará un panel de administración accesible normalmente en `/admin` dentro de Lucy:  
👉 [http://localhost:8081/admin](http://localhost:8081/admin)

---

## Acceso a base de datos

Desde consola del host:
```bash
mysql -h 127.0.0.1 -P 3306 -u root -prootpass
mysql -h 127.0.0.1 -P 3306 -u moodle -pmoodlepass moodle
```

Desde navegador con phpMyAdmin:  
👉 [http://localhost:8082](http://localhost:8082)

---

## MailHog (pruebas de correo)

Ver mails enviados por Moodle o Lucy en:  
👉 [http://localhost:8025](http://localhost:8025)

Configura `.env` de Lucy con:
```env
MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="no-reply@example.test"
MAIL_FROM_NAME="Lucy (dev)"
```

---

## Permisos recomendados

Dar permisos a carpetas necesarias (desde host):

```bash
sudo chown -R $USER:$USER lucy
sudo chown -R $USER:$USER veco/moodle
sudo chown -R $USER:$USER veco/moodledata

# Para Laravel
docker compose exec lucy chown -R application:application /app/storage /app/bootstrap/cache
```

---

## Scripts útiles

En la carpeta `Script` encontrarás:

- **aliases.sh** → alias prácticos:
  - `lartisan` → artisan
  - `lcomposer` → composer
  - `lnpm` → npm
  - `lphp` → php
  - `lmysql` → mysql host
  - `lmailhog` → abre MailHog en navegador

- **start.sh** → arranca todos los servicios (`docker compose up -d`)

Ejemplo de uso:
```bash
source Script/aliases.sh
lartisan migrate
lnpm run build
lcomposer require laravel/sanctum
```

## Versiones PHP para Lucy
Podés cambiar versión de PHP solo editando la etiqueta de la imagen (8.2, 8.3, etc.) y levantando de nuevo:

```
docker compose pull lucy
docker compose up -d lucy
```

## Comandos Iniciales completos y ```env``` para Lucy


**Env**

```
APP_NAME=Lucy
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8081

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=moodle
DB_USERNAME=moodle
DB_PASSWORD=moodlepass

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="no-reply@example.test"
MAIL_FROM_NAME="${APP_NAME}"
```
 
**Comandos**
```
# 1. Clonar el proyecto
git clone https://github.com/usuario/proyecto.git
cd proyecto

# 2. Copiar el archivo de entorno para Lucy
cp lucy/.env.example lucy/.env

# 3. Levantar todos los servicios
./Script/start.sh

# 4. Generar la APP_KEY de Laravel
docker compose exec lucy php artisan key:generate

# 5. Instalar dependencias PHP
docker compose exec composer composer install --no-interaction --prefer-dist

# 6. Instalar dependencias JS
docker compose exec node npm ci
docker compose exec node npm run build

# 7. (Opcional) Reparar permisos de Laravel
docker compose exec lucy chown -R application:application /app/storage /app/bootstrap/cache
docker compose exec lucy chmod -R 775 /app/storage /app/bootstrap/cache
```

Con esto ya queda:

- Moodle en http://localhost:8080
- Lucy (Laravel) en http://localhost:8081
- phpMyAdmin en http://localhost:8082

MailHog en http://localhost:8025

## Para asegurar los permisos

veco/moodledata debe ser escribible por el usuario del contenedor (normalmente www-data, uid 33):

´´´
sudo chown -R 33:33 veco/moodledata
sudo chmod -R 770 veco/moodledata
´´´

o dentro del contenedor

´´´
docker compose exec web bash -lc 'chown -R www-data:www-data /var/moodledata && chmod -R 770 /var/moodledata'
´´´

lucy/ con dueño root. Mejor pasarlo a tu usuario para evitar problemas de escritura desde host:

```
sudo chown -R zeus:zeus lucy
```

zeus es un usuario propietario del docker
CMD
