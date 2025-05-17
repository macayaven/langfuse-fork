#!/bin/bash
set -e

# Get directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Check the status
STATUS=$(bash "${SCRIPT_DIR}/check-upstream.sh" | grep "^STATUS=" | cut -d= -f2)

case $STATUS in
0)
  echo "✅ Already at latest release. No update needed."
  exit 0
  ;;
1)
  echo "📥 Updating to latest release..."
  bash "${SCRIPT_DIR}/update-from-upstream.sh"
  ;;
2)
  echo "⚠️  Your history has diverged from the latest release."
  echo "   Please review the changes and merge manually."
  exit 1
  ;;
3)
  echo "ℹ️  You are ahead of the latest release. No update needed."
  exit 0
  ;;
*)
  echo "🛑 Unknown update status: $STATUS"
  exit 1
  ;;
esac
