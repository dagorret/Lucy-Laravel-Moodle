#!/usr/bin/env bash
# Alias para administrar el stack de Moodle (docker-compose en el directorio del proyecto)

COMPOSE_FILE="docker-compose.yml"

alias moodle.up='docker compose -f ${COMPOSE_FILE} up -d'
alias moodle.down='docker compose -f ${COMPOSE_FILE} down'
alias moodle.ps='docker compose -f ${COMPOSE_FILE} ps'
alias moodle.logs='docker compose -f ${COMPOSE_FILE} logs -f --tail=100'
alias moodle.web.bash='docker compose -f ${COMPOSE_FILE} exec web bash'
alias moodle.db.bash='docker compose -f ${COMPOSE_FILE} exec db bash'
alias moodle.cron.logs='docker compose -f ${COMPOSE_FILE} logs -f cron'
alias moodle.pma='xdg-open http://localhost:8083 2>/dev/null || echo "Abra http://localhost:8083"'
