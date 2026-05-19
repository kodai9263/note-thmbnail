#!/usr/bin/env node
import { writeFile } from "node:fs/promises";

const [url, outputPath] = process.argv.slice(2);

if (!url || !outputPath) {
  console.error("Usage: fetch-note-metadata.mjs <note-url> <output-json>");
  process.exit(1);
}

const match = url.match(/\/n\/(n[a-z0-9]+)/i);
if (!match) {
  console.error("note記事URLから記事キーを取得できませんでした。");
  process.exit(1);
}

const key = match[1];
const apiUrl = `https://note.com/api/v3/notes/${key}`;
const response = await fetch(apiUrl, {
  headers: {
    "user-agent": "Mozilla/5.0",
    accept: "application/json",
  },
});

if (!response.ok) {
  console.error(`note APIの取得に失敗しました: ${response.status}`);
  process.exit(1);
}

const payload = await response.json();
const note = payload.data;

if (!note || note.user?.urlname !== "hikaku9263" || note.status !== "published") {
  console.error("対象アカウントの公開記事として確認できませんでした。");
  process.exit(1);
}

const bodyText = String(note.body ?? "")
  .replace(/<br\s*\/?>/gi, "\n")
  .replace(/<[^>]+>/g, "")
  .replace(/&nbsp;/g, " ")
  .replace(/&amp;/g, "&")
  .replace(/&lt;/g, "<")
  .replace(/&gt;/g, ">")
  .replace(/&quot;/g, '"')
  .replace(/&#39;/g, "'")
  .replace(/\n{3,}/g, "\n\n")
  .trim();

await writeFile(
  outputPath,
  JSON.stringify(
    {
      key,
      url: note.note_url ?? url.replace(/^http:/, "https:").replace(/\?.*$/, ""),
      title: note.name,
      bodyText,
      eyecatch: note.eyecatch,
      publishedAt: note.publish_at,
    },
    null,
    2,
  ),
);

