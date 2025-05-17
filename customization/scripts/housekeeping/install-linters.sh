#!/bin/bash
set -e

echo "📦 Installing shellcheck and shfmt..."

if command -v apt-get &>/dev/null; then
  echo "🔧 Installing shellcheck via apt..."
  sudo apt-get update && sudo apt-get install -y shellcheck
else
  echo "⚠️  Skipping shellcheck (apt not found)"
fi

if ! command -v shfmt &>/dev/null; then
  URL=https://github.com/mvdan/sh/releases/download/v3.11.0/shfmt_v3.11.0_linux_386
  echo "🔽 Downloading shfmt from $URL..."
  curl -sSL -o /tmp/shfmt $URL
  if file /tmp/shfmt | grep -q 'ELF'; then
    chmod +x /tmp/shfmt && sudo mv /tmp/shfmt /usr/local/bin/shfmt
    echo "✅ shfmt installed successfully."
  else
    echo "❌ shfmt download failed or was not a valid binary."
    rm -f /tmp/shfmt
  fi
else
  echo "✅ shfmt is already installed."
fi

echo "✅ Linters installed."
