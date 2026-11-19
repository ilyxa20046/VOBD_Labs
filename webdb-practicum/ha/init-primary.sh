#!/usr/bin/env bash
set -euo pipefail
psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -v replication_password="$REPLICATION_PASSWORD" <<'SQL'
CREATE ROLE replicator LOGIN REPLICATION NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD :'replication_password';
CREATE TABLE public.lab_markers (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  request_id text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT clock_timestamp()
);
SQL
printf '\nhost replication replicator %s scram-sha-256\n' "$LAB_SUBNET" >> "$PGDATA/pg_hba.conf"
