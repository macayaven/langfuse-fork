#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting Langfuse stack..."
echo " Using .env file: .env with values:"
cat .env
docker compose --env-file .env -f ../docker-compose.yml -f docker-compose.override.yml up -d

echo "📋 Showing container logs..."
docker compose logs -f
