#!/bin/zsh
set -euo pipefail

PROJECT_DIR="/Users/yabekoudai/Documents/Codex/2026-05-08/https-editor-note-com-notes-n22010a1bed59"
TARGET_URL="${1:-}"

cd "$PROJECT_DIR"
if [[ -z "$TARGET_URL" ]]; then
  echo "対象のnote記事URLを入力してください。"
  echo "空のままEnterを押すと、新規記事またはアイキャッチ未設定記事を自動確認します。"
  read -r TARGET_URL
fi

./scripts/run-note-thumbnail.sh "$TARGET_URL"

echo
echo "Enterキーで閉じます。"
read -r
