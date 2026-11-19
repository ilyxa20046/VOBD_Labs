#!/usr/bin/env bash
set -euo pipefail
if [[ -e .env ]]; then
  printf 'Existing .env retained.\n'
  exit 0
fi
command -v openssl >/dev/null
umask 077
printf 'POSTGRES_PASSWORD=%s\n' "$(openssl rand -hex 32)" > .env
printf 'REPLICATION_PASSWORD=%s\n' "$(openssl rand -hex 32)" >> .env
printf 'PRIMARY_PORT=55433\nSTANDBY_PORT=55434\nLAB_SUBNET=172.30.80.0/24\n' >> .env
printf 'Created local .env.\n'
