#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-peer$(date +%s)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WG_DIR="${SCRIPT_DIR}/../wireguard"

if ! docker ps --format '{{.Names}}' | grep -q '^wireguard$'; then
  echo "WireGuard container 'wireguard' not running. Start it with: (cd wireguard && docker compose up -d)"
  exit 1
fi

docker exec -it wireguard /app/add-peer "${NAME}"
echo
echo "Client created. Config should be under: wireguard/config/${NAME}/${NAME}.conf"
