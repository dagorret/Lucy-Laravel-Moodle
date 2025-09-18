#!/bin/bash

alias lartisan="docker compose exec lucy php artisan"
alias lcomposer="docker compose exec composer composer"
alias lnpm="docker compose exec node npm"
alias lphp="docker compose exec lucy php"
alias lmysql="mysql -h 127.0.0.1 -P 3306 -u root -prootpass"
alias lmailhog="xdg-open http://localhost:8025 || open http://localhost:8025"
