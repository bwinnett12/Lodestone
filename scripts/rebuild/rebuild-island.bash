#!/bin/bash

###TODO - There has to be more to be done here

sudo nixos-rebuild switch --flake .#Island



# scripts/rebuild/rebuild.bash
#!/usr/bin/env bash
set -euo pipefail

HOSTNAME=$(hostname)
FLAKE_DIR="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

echo "==> Pulling latest changes..."
git -C "$FLAKE_DIR" pull

echo "==> Committing any dirty changes..."
if ! git -C "$FLAKE_DIR" diff --quiet; then
  git -C "$FLAKE_DIR" add -A
  git -C "$FLAKE_DIR" commit -m "auto: pre-rebuild snapshot $(date +%Y-%m-%d_%H:%M)"
fi

echo "==> Rebuilding $HOSTNAME..."
sudo nixos-rebuild switch --flake "$FLAKE_DIR#$HOSTNAME" |& tee /tmp/nixos-rebuild.log &
REBUILD_PID=$!

echo "==> Monitoring build (Ctrl+C to detach, build continues in background)..."
tail -f /tmp/nixos-rebuild.log &
TAIL_PID=$!

# Show system stats while building
watch -n 5 "echo '=== CPU ===' && grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage\"%\"}' && echo '=== Memory ===' && free -h && echo '=== Build log (last 3 lines) ===' && tail -3 /tmp/nixos-rebuild.log"

wait $REBUILD_PID
kill $TAIL_PID 2>/dev/null

echo "==> Done! Exit code: $?"