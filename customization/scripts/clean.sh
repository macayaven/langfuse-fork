#!/usr/bin/env bash
set -euo pipefail

echo "🧹 Cleaning up Langfuse resources..."
echo "🛑 Stopping and removing containers..."
docker compose down

echo "🗑️ Removing all Docker Compose resources (networks, volumes)..."
docker compose down -v --remove-orphans

echo "✅ Cleanup complete!"
