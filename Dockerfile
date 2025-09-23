# Dockerfile
FROM webdevops/php-apache-dev:8.2

# Requisitos base e intl (Filament 4 lo exige)
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg ca-certificates libicu-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-enable intl

# Node 20 (para npm / vite)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    node --version && npm --version

# Composer (última estable)
RUN php -r "copy('https://getcomposer.org/installer','composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php && composer --version

# Entorno para trabajar con tu UID/GID y caches propios
ENV APPLICATION_UID=10001 \
    APPLICATION_GID=10001 \
    WEB_DOCUMENT_ROOT=/app/public \
    HOME=/home/app \
    COMPOSER_HOME=/home/app/.composer \
    COMPOSER_CACHE_DIR=/home/app/.composer/cache

# HOME para composer/npm
RUN mkdir -p /home/app/.composer/cache && chown -R 10001:10001 /home/app

