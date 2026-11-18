#!/bin/sh
# print visible text per line of a page's <main> (line numbers kept) to help map copy
f=$1; s=$(grep -n '<main' "$f" | head -1 | cut -d: -f1); e=$(grep -n '</main>' "$f" | tail -1 | cut -d: -f1)
awk -v s=$s -v e=$e 'NR>=s && NR<=e { line=$0; gsub(/<style.*<\/style>/, "", line); gsub(/<[^>]*>/, " | ", line); gsub(/( \| )+/, " | ", line); gsub(/^ \| | \| $/, "", line); if (length(line) > 1 && line != "|") print NR": "line }' "$f"
