#!/bin/bash
set -e

# Get the customization directory path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CUSTOM_PATH=$(cd "${SCRIPT_DIR}/../../.." && pwd)

echo "🔍 Running linters on ${CUSTOM_PATH}/customization..."

echo "🔹 shellcheck:"
find "${CUSTOM_PATH}/customization" -name "*.sh" -exec shellcheck {} + || echo "⚠️  shellcheck reported issues."

echo "🔹 shfmt:"
find "${CUSTOM_PATH}/customization" -name "*.sh" -exec shfmt -i 2 -w {} + || echo "⚠️  shfmt reported formatting issues."

echo "🔹 docker compose config:"
(cd "${CUSTOM_PATH}" && docker compose config) || echo "⚠️  docker compose config failed"

echo "✅ Linting complete."
