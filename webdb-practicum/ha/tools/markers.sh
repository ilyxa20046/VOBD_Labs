#!/usr/bin/env bash
set -euo pipefail
mkdir -p evidence
lab_journal=evidence/acknowledged.csv
if [[ -e "$lab_journal" ]]; then
  printf 'Journal already exists. Preserve it and choose a new experiment directory.\n' >&2
  exit 1
fi
printf 'request_id,client_ack_utc\n' > "$lab_journal"
marker_seq=0
marker_run="$(date -u +%Y%m%dT%H%M%SZ)"
while :; do
  marker_seq=$((marker_seq + 1))
  marker_id="marker_${marker_run}_${marker_seq}"
  if marker_ack="$(docker compose exec -T db_primary psql -XqAt -v ON_ERROR_STOP=1 -U lab_admin -d webdb \
      -c "INSERT INTO public.lab_markers(request_id) VALUES ('$marker_id') RETURNING request_id;")"; then
    [[ "$marker_ack" == "$marker_id" ]]
    printf '%s,%s\n' "$marker_id" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$lab_journal"
    printf 'ACK %s\n' "$marker_id"
  else
    printf 'Write failed; acknowledged journal preserved.\n' >&2
    exit 1
  fi
  sleep 1
done
