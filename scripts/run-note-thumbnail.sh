#!/bin/zsh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROMPT_FILE="$PROJECT_DIR/prompts/generate-note-thumbnail.md"
LOG_DIR="$PROJECT_DIR/logs"
LAST_OUTPUT="$LOG_DIR/last-run.md"
APP_CODEX="/Applications/Codex.app/Contents/Resources/codex"
TARGET_URL="${1:-}"

mkdir -p "$LOG_DIR" "$PROJECT_DIR/assets/generated"

if [[ -x "$APP_CODEX" ]]; then
  CODEX_BIN="$APP_CODEX"
elif command -v codex >/dev/null 2>&1; then
  CODEX_BIN="$(command -v codex)"
else
  echo "codex コマンドが見つかりません。Codex CLI を使える状態にしてから再実行してください。"
  exit 1
fi

echo "note サムネイル生成を開始します..."
echo "プロジェクト: $PROJECT_DIR"
if [[ -n "$TARGET_URL" ]]; then
  echo "対象URL: $TARGET_URL"
fi
echo

if [[ -n "$TARGET_URL" ]]; then
  PROMPT_INPUT="$(mktemp)"
  trap 'rm -f "$PROMPT_INPUT"' EXIT
  {
    cat "$PROMPT_FILE"
    echo
    echo "<target_note_url>"
    echo "$TARGET_URL"
    echo "</target_note_url>"
  } > "$PROMPT_INPUT"
else
  PROMPT_INPUT="$PROMPT_FILE"
fi

"$CODEX_BIN" \
  --search \
  exec \
  --ephemeral \
  --sandbox workspace-write \
  -C "$PROJECT_DIR" \
  -o "$LAST_OUTPUT" \
  - < "$PROMPT_INPUT"

echo
echo "完了しました。最後の出力: $LAST_OUTPUT"
