#!/usr/bin/env sh
set -eu
if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then echo "Uso: $0 backup.sql.gz"; exit 2; fi
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
set -a
. "$ROOT/../.env"
set +a
printf 'Esto reemplazará la base FiberTrack. Escriba RESTAURAR: '
read -r answer
[ "$answer" = RESTAURAR ] || exit 1
gunzip -c "$1" | docker compose --env-file "$ROOT/../.env" -f "$ROOT/docker-compose.yml" exec -T postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" --single-transaction
