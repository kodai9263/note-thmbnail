# note サムネイル手動生成

note アカウント `hikaku9263` の公開記事を確認し、新しい記事またはアイキャッチ未設定の記事があるときだけ、note 用の 1280x670px PNG サムネイルを生成するための手動起動プロジェクトです。

## 使い方

デスクトップの `noteサムネ生成.command` をダブルクリックすると、Codex が一時セッションで起動します。
起動後に対象の note 記事URLを入力できます。空のまま Enter を押すと、新規記事またはアイキャッチ未設定記事を自動確認します。

```sh
./scripts/run-note-thumbnail.sh
```

生成されたサムネイルは `assets/generated/` に保存します。既存の `assets/note-csr-thumbnail.png` と `assets/note-ssr-thumbnail.png` の雰囲気に合わせて、「React初心者メモ」の落ち着いた技術記事風デザインにします。

## 方針

- note へのアップロードや公開記事の編集は実行しません。
- 対象記事を確定できない場合は、誤生成を避けて停止します。
- 実行履歴を増やしにくくするため、`codex --search exec --ephemeral` で起動します。
- npm 版 Codex が壊れている環境でも動くように、macOS アプリ同梱の Codex CLI を優先します。
- 結果はターミナルに表示し、最後の出力は `logs/last-run.md` に残します。
