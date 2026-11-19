#!/usr/bin/env bash
set -euo pipefail
lab_base="${1:-http://127.0.0.1:8080}"
lab_tmp="$(mktemp)"
trap 'rm -f "$lab_tmp"' EXIT
for lab_route in /health /health/db; do
  lab_code="$(curl --max-time 10 -sS -o "$lab_tmp" -w '%{http_code}' "$lab_base$lab_route")"
  [[ "$lab_code" == 200 ]]
  grep -q '"status":"ok"' "$lab_tmp"
  printf 'PASS %s\n' "$lab_route"
done
lab_code="$(curl --max-time 10 -sS -o "$lab_tmp" -w '%{http_code}' "$lab_base/route-that-does-not-exist")"
[[ "$lab_code" == 404 ]]
printf 'PASS unknown route\n'
