#!/bin/zsh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROMPT_FILE="$PROJECT_DIR/prompts/generate-note-thumbnail.md"
LOG_DIR="$PROJECT_DIR/logs"
LAST_OUTPUT="$LOG_DIR/last-run.md"

mkdir -p "$LOG_DIR" "$PROJECT_DIR/assets/generated"

if ! command -v codex >/dev/null 2>&1; then
  echo "codex コマンドが見つかりません。Codex CLI を使える状態にしてから再実行してください。"
  exit 1
fi

echo "note サムネイル生成を開始します..."
echo "プロジェクト: $PROJECT_DIR"
echo

codex exec \
  --ephemeral \
  --search \
  --sandbox workspace-write \
  -C "$PROJECT_DIR" \
  -o "$LAST_OUTPUT" \
  - < "$PROMPT_FILE"

echo
echo "完了しました。最後の出力: $LAST_OUTPUT"

