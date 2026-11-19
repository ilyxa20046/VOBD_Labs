#!/usr/bin/env bash
set -euo pipefail
install -d -m 700 -o postgres -g postgres "$PGDATA"
lab_passfile=/var/lib/postgresql/replication.pgpass
umask 077
printf 'db_primary:5432:replication:replicator:%s\n' "$REPLICATION_PASSWORD" > "$lab_passfile"
chown postgres:postgres "$lab_passfile"
chmod 600 "$lab_passfile"
if [[ ! -s "$PGDATA/PG_VERSION" ]]; then
  gosu postgres pg_basebackup \
    -d "host=db_primary port=5432 user=replicator passfile=$lab_passfile application_name=lab_standby" \
    -D "$PGDATA" -Fp -Xs -P -R
fi
exec /usr/local/bin/docker-entrypoint.sh postgres
