#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ">> [CLEAN] Bajando VECO (Moodle+DB) sin tocar volúmenes..."
cd "$ROOT_DIR"
docker compose down --remove-orphans || true

# Si existe el stack de Lucy, también lo bajo (por si quedaron huérfanos que ocupan puertos/red)
if [ -f "$ROOT_DIR/lucy/docker-compose.yml" ]; then
  echo ">> [CLEAN] Bajando stack de Lucy/Samuel..."
  ( cd "$ROOT_DIR/lucy" && docker compose down --remove-orphans || true )
fi

echo ">> [CLEAN] Listo. Contenedores parados. Datos intactos."

