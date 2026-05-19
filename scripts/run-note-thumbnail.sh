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
  METADATA_JSON="$LOG_DIR/last-note.json"
  node "$PROJECT_DIR/scripts/fetch-note-metadata.mjs" "$TARGET_URL" "$METADATA_JSON"

  HAS_EYECATCH="$(node -e 'const fs=require("fs"); const d=JSON.parse(fs.readFileSync(process.argv[1], "utf8")); console.log(d.eyecatch ? "true" : "false")' "$METADATA_JSON")"
  TITLE="$(node -e 'const fs=require("fs"); const d=JSON.parse(fs.readFileSync(process.argv[1], "utf8")); console.log(d.title)' "$METADATA_JSON")"
  NOTE_URL="$(node -e 'const fs=require("fs"); const d=JSON.parse(fs.readFileSync(process.argv[1], "utf8")); console.log(d.url)' "$METADATA_JSON")"

  if [[ "$HAS_EYECATCH" == "true" ]]; then
    {
      echo "今回は生成していません。"
      echo
      echo "- 保存パス: なし"
      echo "- 対象記事URL: $NOTE_URL"
      echo "- 生成しなかった理由: 既にアイキャッチが設定されています。"
    } | tee "$LAST_OUTPUT"
    exit 0
  fi

  OUTPUT_PATH="$(
    CLANG_MODULE_CACHE_PATH="$PROJECT_DIR/tmp/clang-module-cache" \
      swift "$PROJECT_DIR/scripts/render-note-thumbnail.swift" "$METADATA_JSON" "$PROJECT_DIR/assets/generated/"
  )"

  {
    echo "サムネイルを生成しました。"
    echo
    echo "- 保存パス: $OUTPUT_PATH"
    echo "- 対象記事URL: $NOTE_URL"
    echo "- 記事タイトル: $TITLE"
    echo "- サムネイルの意図: React初心者メモのシリーズ感に合わせ、記事の要点を右側の概念図で整理しました。"
  } | tee "$LAST_OUTPUT"
  exit 0
fi

"$CODEX_BIN" \
  --search \
  exec \
  --ephemeral \
  --sandbox workspace-write \
  -C "$PROJECT_DIR" \
  -o "$LAST_OUTPUT" \
  - < "$PROMPT_FILE"

echo
echo "完了しました。最後の出力: $LAST_OUTPUT"
