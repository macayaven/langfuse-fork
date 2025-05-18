#!/usr/bin/env bash
set -euo pipefail

OFICIAL_LANGFUSE_REPO="https://github.com/langfuse/langfuse.git"

echo "🔍 Checking sync status with upstream Langfuse releases..."

# Check for required tools for GitHub API method
if ! command -v curl &>/dev/null || ! command -v jq &>/dev/null; then
  echo "⚠️ Warning: 'curl' or 'jq' not found. Will attempt fallback to git-based release detection."
  USE_FALLBACK="true"
else
  USE_FALLBACK="false"
fi

# Ensure upstream remote is configured
if ! git remote get-url upstream >/dev/null 2>&1; then
  echo "🛑 Error: 'upstream' remote not configured. Please add the main Langfuse repository as 'upstream'."
  echo "   Example: git remote add upstream $OFICIAL_LANGFUSE_REPO"
  exit 1
fi

# Check and advise on upstream push URL
UPSTREAM_FETCH_URL=$(git remote get-url upstream)
UPSTREAM_PUSH_URL=$(git remote get-url --push upstream 2>/dev/null || echo "$UPSTREAM_FETCH_URL")

if [ "$UPSTREAM_PUSH_URL" = "$UPSTREAM_FETCH_URL" ] || [ -z "$UPSTREAM_PUSH_URL" ]; then
  echo ""
  echo "⚠️  Warning: Your 'upstream' remote is likely configured to allow pushes."
  echo "   To prevent accidental pushes to the main Langfuse repository, we are disabling pushes."
  echo "   Doing it by running:"
  git remote set-url --push upstream no_push
  echo ""
fi

echo "⬇️  Fetching latest data from upstream (langfuse/langfuse)..."
git fetch upstream main --tags --force || echo "ℹ️ Note: git fetch had some issues, proceeding..."

LATEST_RELEASE_TAG=""
UPSTREAM_REPO_URL=$(git remote get-url upstream)
UPSTREAM_REPO_PATH=$(echo "$UPSTREAM_REPO_URL" | sed -E 's/git@github.com:|https:\/\/github.com\///' | sed 's/\\.git$//')

if [ "$USE_FALLBACK" = "false" ]; then
  echo "ℹ️ Attempting to fetch latest release tag from GitHub API for ${UPSTREAM_REPO_PATH}..."
  LATEST_RELEASE_TAG=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${UPSTREAM_REPO_PATH}/releases/latest" | jq -r .tag_name)
  if [ -z "$LATEST_RELEASE_TAG" ] || [ "$LATEST_RELEASE_TAG" = "null" ]; then
    echo "⚠️ Could not fetch latest release tag from GitHub API. Will attempt fallback."
    LATEST_RELEASE_TAG=""
  fi
fi

if [ -z "$LATEST_RELEASE_TAG" ]; then
  echo "ℹ️ Using fallback: attempting to find latest tag on upstream/main..."
  LATEST_RELEASE_TAG=$(git describe --tags --abbrev=0 upstream/main 2>/dev/null || echo "")
  if [ -z "$LATEST_RELEASE_TAG" ]; then
    echo "🛑 Error: Could not determine latest release tag using API or fallback method."
    echo "   Please ensure 'upstream' remote is correct and 'upstream/main' is fetched."
    exit 1
  else
    echo "ℹ️ Found latest tag via fallback: $LATEST_RELEASE_TAG"
  fi
fi

echo "🔔 Latest determined Langfuse release: $LATEST_RELEASE_TAG"

LOCAL_HEAD=$(git rev-parse @)
LATEST_RELEASE_COMMIT=$(git rev-parse "$LATEST_RELEASE_TAG^{commit}" 2>/dev/null)

if [ -z "$LATEST_RELEASE_COMMIT" ]; then
  echo "🛑 Error: Could not find commit for tag '$LATEST_RELEASE_TAG'. Ensure tags are fetched correctly."
  echo "   Try running: git fetch upstream --tags --force"
  exit 1
fi

MERGE_BASE=$(git merge-base "$LOCAL_HEAD" "$LATEST_RELEASE_COMMIT")

# Output status information in a parseable format
if [ "$LOCAL_HEAD" = "$LATEST_RELEASE_COMMIT" ]; then
  echo "✅ You are at the latest Langfuse release ($LATEST_RELEASE_TAG)."
  echo "STATUS=0"
  echo "MESSAGE=at_latest"
elif [ "$LOCAL_HEAD" = "$MERGE_BASE" ]; then
  echo "⬇️  You are BEHIND the latest Langfuse release ($LATEST_RELEASE_TAG)."
  echo "   Your commit: $(git rev-parse --short "$LOCAL_HEAD") ($(git log -1 --pretty=%s "$LOCAL_HEAD"))"
  echo "   Release commit: $(git rev-parse --short "$LATEST_RELEASE_COMMIT") ($(git log -1 --pretty=%s "$LATEST_RELEASE_COMMIT"))"
  echo "   Consider updating your local branch/main from 'upstream' and rebasing/merging if necessary."
  echo "STATUS=1"
  echo "MESSAGE=behind_latest"
  echo "TAG=$LATEST_RELEASE_TAG"
elif [ "$LATEST_RELEASE_COMMIT" = "$MERGE_BASE" ]; then
  echo "⬆️  You are AHEAD of the latest Langfuse release ($LATEST_RELEASE_TAG)."
  echo "   Your commit: $(git rev-parse --short "$LOCAL_HEAD") leads release $LATEST_RELEASE_TAG."
  echo "STATUS=3"
  echo "MESSAGE=ahead_latest"
else
  echo "⚠️  Your history has DIVERGED from the latest Langfuse release ($LATEST_RELEASE_TAG)!"
  echo "   Your commit: $(git rev-parse --short "$LOCAL_HEAD") ($(git log -1 --pretty=%s "$LOCAL_HEAD"))"
  echo "   Release commit: $(git rev-parse --short "$LATEST_RELEASE_COMMIT") ($(git log -1 --pretty=%s "$LATEST_RELEASE_COMMIT"))"
  echo "   Common ancestor: $(git rev-parse --short "$MERGE_BASE") ($(git log -1 --pretty=%s "$MERGE_BASE"))"
  echo "STATUS=2"
  echo "MESSAGE=diverged"
  echo "TAG=$LATEST_RELEASE_TAG"
fi

echo
echo "ℹ️ Note: This script checks against the latest *release tag* of ${UPSTREAM_REPO_PATH}."
