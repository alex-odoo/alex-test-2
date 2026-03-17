#!/usr/bin/env bash
set -euo pipefail

DEPLOY_DIR="/opt/rteam-fze"
BACKUP_DIR="/opt/rteam-fze/backups"
DB_NAME="${POSTGRES_DB:-odoo}"
DB_USER="${POSTGRES_USER:-odoo}"
KEEP_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/odoo_${DB_NAME}_${TIMESTAMP}.sql.gz"

mkdir -p "$BACKUP_DIR"
cd "$DEPLOY_DIR"

echo ">>> Backing up database '$DB_NAME' to $BACKUP_FILE..."
docker compose exec -T db pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

echo ">>> Backup complete: $BACKUP_FILE ($(du -sh "$BACKUP_FILE" | cut -f1))"

# Remove backups older than KEEP_DAYS days
echo ">>> Removing backups older than $KEEP_DAYS days..."
find "$BACKUP_DIR" -name "odoo_*.sql.gz" -mtime +"$KEEP_DAYS" -delete

echo ">>> Backup rotation done. Current backups:"
ls -lh "$BACKUP_DIR"/odoo_*.sql.gz 2>/dev/null || echo "  (none)"
