#!/bin/bash

echo "Levantando servicios..."
docker compose up -d

echo "Reparando permisos en Lucy y Moodle..."
docker compose exec lucy chown -R application:application /app/storage /app/bootstrap/cache || true
docker compose exec lucy chmod -R 775 /app/storage /app/bootstrap/cache || true

echo "Servicios levantados:"
docker compose ps
