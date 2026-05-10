#!/bin/zsh
set -euo pipefail

PROJECT_DIR="/Users/yabekoudai/Documents/Codex/2026-05-08/https-editor-note-com-notes-n22010a1bed59"

cd "$PROJECT_DIR"
./scripts/run-note-thumbnail.sh

echo
echo "Enterキーで閉じます。"
read -r

