#!/usr/bin/env bash
set -euo pipefail
if [[ -e .env ]]; then
  printf 'Existing .env retained.\n'
  exit 0
fi
command -v openssl >/dev/null
umask 077
for lab_secret in POSTGRES_PASSWORD OWNER_DB_PASSWORD APP_DB_PASSWORD LAB_USER_TOKEN LAB_OTHER_TOKEN LAB_MANAGER_TOKEN; do
  printf '%s=%s\n' "$lab_secret" "$(openssl rand -hex 32)"
done > .env
printf 'WEB_PORT=8080\nDB_PORT=55432\n' >> .env
printf 'Created local .env. Do not commit it.\n'
