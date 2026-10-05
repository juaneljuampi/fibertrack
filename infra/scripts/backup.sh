#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
set -a
. "$ROOT/../.env"
set +a
STAMP=$(date +%Y-%m-%d_%H%M)
mkdir -p "$ROOT/backups"
docker compose --env-file "$ROOT/../.env" -f "$ROOT/docker-compose.yml" exec -T postgres pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" | gzip > "$ROOT/backups/fibertrack_${STAMP}.sql.gz"
find "$ROOT/backups" -name 'fibertrack_*.sql.gz' -mtime +30 -delete
