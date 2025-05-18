#!/usr/bin/env bash

# ⚠️ Maintainer Setup Script
# This script is intended for the fork maintainer to set up the project.
# For team members, please use the following workflow instead:
#    1. git clone https://github.com/your-username/langfuse-fork.git
#    2. cd langfuse-fork
#    3. make env && make up

# ---------------------------------------------
# Langfuse Fork Bootstrap Script
# Author: Carlos Crespo
# Description: Sets up fork from upstream, configures remotes,
# generates .env.local.example, and prepares customization onboarding.
# ---------------------------------------------

set -euo pipefail

# --- CONFIGURATION ---
OFFICIAL_LANGFUSE_REPO="https://github.com/langfuse/langfuse.git"
FORKED_LANGFUSE_REPO="https://github.com:macayaven/langfuse-fork.git"
TARGET_DIR="customization"
ENV_TEMPLATE_FILE=".env.local.example"

# --- STEP 0: Check Docker & Docker Compose ---
echo "🔍 Checking for Docker and Docker Compose..."
if ! command -v docker &>/dev/null; then
  echo "❌ Docker not found. Install Docker before continuing: https://docs.docker.com/get-docker/"
  exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "🔧 Ensuring current user is in docker group..."
  sudo usermod -aG docker "$USER" || true
  echo "ℹ️  Log out and back in to apply docker group changes if needed."
fi

if ! docker compose version &>/dev/null; then
  echo "🔧 Docker Compose v2 not found. Installing to ~/.docker/cli-plugins..."
  mkdir -p "$HOME/.docker/cli-plugins"
  curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
    -o "$HOME/.docker/cli-plugins/docker-compose"
  chmod +x "$HOME/.docker/cli-plugins/docker-compose"
  echo "✅ Docker Compose installed locally."
else
  echo "✅ Docker Compose is available."
fi

# --- STEP 1: Clone Langfuse from upstream ---
echo "📥 Cloning upstream Langfuse..."
git clone "$OFFICIAL_LANGFUSE_REPO" "$TARGET_DIR"
cd "$TARGET_DIR"
# --- STEP 2: Configure remotes ---
echo "🔧 Setting 'origin' as your personal repo and 'upstream' as official Langfuse..."
git remote rename origin upstream

# Add your personal repo
git remote add origin "$FORKED_LANGFUSE_REPO"

# Make origin the default for push/pull
git remote set-url origin "$FORKED_LANGFUSE_REPO"
git remote set-url --push origin "$FORKED_LANGFUSE_REPO"
git branch --set-upstream-to=origin/main main || git branch --set-upstream-to=origin/master master

# Prevent accidental pushes to upstream
git remote set-url --push upstream no_push

# --- STEP 3: Generate .env.local.example with placeholders ---
echo "📝 Creating .env.local.example..."
cat >"$ENV_TEMPLATE_FILE" <<EOF
# =============================================================================
# SECURITY & AUTHENTICATION
# =============================================================================
# Security keys for encryption and authentication
SALT=your-random-salt-key
ENCRYPTION_KEY=your-random-encryption-key
NEXTAUTH_SECRET=your-random-nextauth-secret
NEXTAUTH_URL=http://localhost:3000

# =============================================================================
# DATABASE CONFIGURATION
# =============================================================================
# PostgreSQL
POSTGRES_USER=postgres
POSTGRES_PASSWORD=yourpassword
POSTGRES_DB=postgres
DATABASE_URL=postgresql://postgres:yourpassword@postgres:5432/postgres
DIRECT_URL=postgresql://postgres:yourpassword@postgres:5432/postgres

# ClickHouse
CLICKHOUSE_USER=your-clickhouse-user
CLICKHOUSE_PASSWORD=your-clickhouse-password
CLICKHOUSE_URL=http://clickhouse:8123
CLICKHOUSE_MIGRATION_URL=clickhouse://clickhouse:9000
CLICKHOUSE_CLUSTER_ENABLED=false

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_AUTH=your-redis-password

# =============================================================================
# STORAGE CONFIGURATION
# =============================================================================
# Minio/S3 Root Credentials
MINIO_ROOT_USER=your-minio-root-user
MINIO_ROOT_PASSWORD=your-minio-root-password

# S3 Access Keys (using Minio root credentials)
LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID=your-minio-root-user
LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID=your-minio-root-user
LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID=your-minio-root-user
LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY=your-minio-secret
LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY=your-minio-secret
LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY=your-minio-secret

# S3 Event Upload Configuration
LANGFUSE_S3_EVENT_UPLOAD_BUCKET=langfuse
LANGFUSE_S3_EVENT_UPLOAD_REGION=us-east-1
LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT=http://minio:9000  # Internal Docker network port
LANGFUSE_S3_EVENT_UPLOAD_FORCE_PATH_STYLE=true
LANGFUSE_S3_EVENT_UPLOAD_PREFIX=events/

# S3 Media Upload Configuration
LANGFUSE_S3_MEDIA_UPLOAD_BUCKET=langfuse
LANGFUSE_S3_MEDIA_UPLOAD_REGION=us-east-1
LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT=http://minio:9000  # Internal Docker network port
LANGFUSE_S3_MEDIA_UPLOAD_FORCE_PATH_STYLE=true

# S3 Batch Export Configuration
LANGFUSE_S3_BATCH_EXPORT_ENABLED=false
LANGFUSE_S3_BATCH_EXPORT_BUCKET=langfuse
LANGFUSE_S3_BATCH_EXPORT_REGION=us-east-1
LANGFUSE_S3_BATCH_EXPORT_ENDPOINT=http://minio:9000  # Internal Docker network port
LANGFUSE_S3_BATCH_EXPORT_FORCE_PATH_STYLE=true
LANGFUSE_S3_BATCH_EXPORT_PREFIX=exports/

# =============================================================================
# EMAIL CONFIGURATION
# =============================================================================
EMAIL_FROM_ADDRESS=""  # Defines the email address to use as the from address
SMTP_CONNECTION_URL=""  # Defines the connection url for smtp server

# =============================================================================
# GENERAL SETTINGS
# =============================================================================
TELEMETRY_ENABLED=false
LANGFUSE_LOG_LEVEL=debug
NEXT_PUBLIC_LANGFUSE_RUN_NEXT_INIT=false  # Speeds up local development
EOF

echo "✅ Comprehensive .env.local.example created."

# --- STEP 4: Copy override file if present ---
OVERRIDE_SOURCE_PATH="$(dirname "$0")/../docker-compose.override.yml"
if [ -f "$OVERRIDE_SOURCE_PATH" ]; then
  echo "📦 Copying docker-compose.override.yml into project root..."
  cp "$OVERRIDE_SOURCE_PATH" .
fi

# --- STEP 5: Push to personal GitHub repo ---
echo "🚀 Pushing code to your personal fork..."
git push -u origin main || git push -u origin master

echo "🎉 Bootstrap complete."
echo "👉 Next steps:"
echo "   1. follow the user workflow instructions to deploy a local customized langfuse stack"

echo "⏱️ Regularly update your fork from upstream:"
echo "   1.A github action will notify if new releases are available"
echo "   or proactively check for updates with:"
echo "   1.B make check"
echo "   Update your fork with:"
echo "   2.  make update"
