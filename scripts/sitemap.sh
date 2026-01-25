#!/usr/bin/env bash

URL="https://isthere.money"

cat << EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
EOF

fd -t f '^index\.html$' . | while read -r file; do
  # Полное UTC-время изменения файла
  lastmod=$(date -u -r "$file" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)

  # Формируем путь
  path="${file#./}"
  path="${path#./}"

  # Убираем /src/ из пути
  clean_path="${path/src\//}"

  # Формируем URL всегда с /index.html
  loc="${URL}/${clean_path}"
  loc=${loc/index.html/}
  cat << EOF
  <url>
    <loc>${loc}</loc>
    <lastmod>${lastmod}</lastmod>
    <changefreq>daily</changefreq>
    <priority>0.9</priority>
  </url>
EOF
done

echo "</urlset>"