#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# `docker compose down` removes the containers AND the project network.
# Removing the network is what releases the container's IP — a plain `stop`
# (or Ctrl-C) leaves the network and containers in place still holding it.
echo "=============================================="
echo " Stopping ZoneMinder stack and removing network"
echo " (releases the container IP so the next ./up.sh"
echo "  starts cleanly)"
echo "=============================================="

exec docker compose down --remove-orphans "$@"
