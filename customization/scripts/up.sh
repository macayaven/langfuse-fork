#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting Langfuse stack..."
docker compose -f ../docker-compose.yml -f docker-compose.override.yml up -d

echo "📋 Showing container logs..."
docker compose logs -f
