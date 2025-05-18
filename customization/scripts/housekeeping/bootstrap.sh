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

# --- STEP 3: Push to personal GitHub repo ---
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
