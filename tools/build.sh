#!/bin/sh
# Rebuild every page from its live-site capture (tools/base) + its copy script (tools/pages).
# usage: sh tools/build.sh [page ...]     e.g. sh tools/build.sh index
set -e
cd "$(dirname "$0")/.."
pages="$*"; [ -z "$pages" ] && pages=$(ls tools/pages | sed 's/\.pl$//')
for p in $pages; do
  perl tools/pages/$p.pl
  perl tools/sitewide.pl $p.html >/dev/null
  perl -0pi -e 's/(<div class="relative flex h-16[^"]*") style="opacity: [0-9.]+;"/$1/g' $p.html
done
