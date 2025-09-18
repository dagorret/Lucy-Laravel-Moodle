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

Esto inicia **Moodle, Lucy, MariaDB, phpMyAdmin, MailHog, Node y Composer**.

### 3. Verificar servicios
```bash
docker compose ps
```

---

## Lucy (Laravel)

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
