#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob
psql -X -v ON_ERROR_STOP=1 <<'SQL'
CREATE TABLE IF NOT EXISTS app.schema_migrations (
  version text PRIMARY KEY,
  applied_at timestamptz NOT NULL DEFAULT clock_timestamp()
);
REVOKE ALL ON app.schema_migrations FROM web_app;
SQL
for lab_file in /migrations/[0-9]*.sql; do
  lab_version="$(basename "$lab_file" .sql)"
  if [[ ! "$lab_version" =~ ^[0-9]{3}_[a-z0-9_]+$ ]]; then
    printf 'Invalid migration name: %s\n' "$lab_version" >&2
    exit 1
  fi
  lab_applied="$(psql -X -At -v ON_ERROR_STOP=1 -c "SELECT 1 FROM app.schema_migrations WHERE version = '$lab_version'")"
  if [[ "$lab_applied" == 1 ]]; then
    printf 'Already applied: %s\n' "$lab_version"
    continue
  fi
  psql -X -v ON_ERROR_STOP=1 <<SQL
BEGIN;
\i $lab_file
INSERT INTO app.schema_migrations(version) VALUES ('$lab_version');
COMMIT;
SQL
  printf 'Applied: %s\n' "$lab_version"
done
