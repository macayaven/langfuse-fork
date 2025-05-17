#!/usr/bin/env bash
set -euo pipefail

# Define the forked repository URL
FORKED_LANGFUSE_REPO="https://github.com:macayaven/langfuse-fork.git"

# Clone the forked repository
echo "📥 Cloning forked Langfuse..."
git clone "$FORKED_LANGFUSE_REPO" langfuse-fork

# Navigate to the cloned directory
cd langfuse-fork || echo "❌ Failed to navigate to langfuse-fork directory. Aborting." && exit 1

# Make origin the default for push/pull
git remote set-url origin "$FORKED_LANGFUSE_REPO"
git remote set-url --push origin "$FORKED_LANGFUSE_REPO"
git branch --set-upstream-to=origin/main main || git branch --set-upstream-to=origin/master master

# Prevent accidental pushes to upstream
git remote set-url --push upstream no_push
