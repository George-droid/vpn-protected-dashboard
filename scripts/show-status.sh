#!/usr/bin/env bash
set -euo pipefail

if ! docker ps --format '{{.Names}}' | grep -q '^wireguard$'; then
  echo "WireGuard container 'wireguard' not running. Start it with: (cd wireguard && docker compose up -d)"
  exit 1
fi

docker exec -it wireguard wg show
